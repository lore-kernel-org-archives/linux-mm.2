Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF45C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 18:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B9E6B0095; Mon, 31 Aug 2026 14:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3B56B0096; Mon, 31 Aug 2026 14:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D33D6B0098; Mon, 31 Aug 2026 14:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF506B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:25:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FAE080210
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:25:04 +0000 (UTC)
X-FDA: 85162391328.11.AC0943C
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5DF80140009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:25:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=recall.ai header.s=google header.b=Hq2qGXtb;
	spf=pass (imf23.hostedemail.com: domain of mike@recall.ai designates 209.85.210.182 as permitted sender) smtp.mailfrom=mike@recall.ai;
	dmarc=pass (policy=reject) header.from=recall.ai;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788200702;
	b=h4vDLyc8RItz0a7xKjcxzaFQALcquHDijSYG/YxARXSX1Vs0mV0l7go/L7P+ABRovtSkTS
	XmZS9Z3wF9ukdY+L0Ds7AXe3n9MsTFqIi6z0U5hAzUJB7hlWjg7HzBXRC9IMucv2cxDuhk
	2rEactqysQx5nKhHxrZG1sn1h7wDp5g=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=recall.ai header.s=google header.b=Hq2qGXtb;
	spf=pass (imf23.hostedemail.com: domain of mike@recall.ai designates 209.85.210.182 as permitted sender) smtp.mailfrom=mike@recall.ai;
	dmarc=pass (policy=reject) header.from=recall.ai;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788200702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hbV5Wg8l0nJ8T1Mygha+CfNYcTHfR/M+eEDDy9eLWnc=;
	b=LkFKU8K2lw9RB9tAOuHu0ukN2Wmvp9S/zZaYPy26MB/cbW7b03t2VxPLKO3UAQCnhrMQj5
	nP991ZAI2BuDIenNHyLV5GYwTIuTY86xnYk0273SPO0MkAXAQ0w6CynRG6H6yNXZoSA5fH
	SOrR/T00BZftof/Ygjc7Pino7HNHtvw=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8541875f596so2071404b3a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788200701; cv=none;
        d=google.com; s=arc-20260327;
        b=VBz4vBtWwYZd/4+4PsfV8ppIMttSrnHFZBI7ltwtbF24En9McazgH4yBUq4f/hx+1S
         gb6hFupah3Pz8e1LaTqNM0ovsKA/RML8CRQEr+IHk+cibzjeYX8JEeHIXvMFb9Dl20T/
         f1o3wCOTLt01G5e2irYeNNFJ8rAMgogNbLpTkNWKmiVaDfdpmefoKb09kT9pgdqCUqeX
         Wyj4jVOargxWJIRc6dZTIZawjMq1qUFq3h6+D9LY9an6MlnMjbGXhLcAFp4MCApscbym
         xPbAqHE3jtmYvC9T+8R2yFAaE4ma+b1ZxkCBw11inevtOXEYa7DbLJDBdgVYdIn4IcnP
         qAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hbV5Wg8l0nJ8T1Mygha+CfNYcTHfR/M+eEDDy9eLWnc=;
        fh=vQXvw7WiGQ9ewuzNBl3WVswNmgKGxBJw4lbk1Bw2FSk=;
        b=KZo5H4zT5AYQXXEJymn8Z7uQK7KHLZ9QCHZ6fwQ2MFwWWTb+STpHgqUuPe8KjV8s8l
         3LNjHNk+RiYV9fC9CjgL2e0JYunT2D4o36sXiJnKB1DIl4yNZfolek3xk/82uBL53/0N
         4Fb5L2mS8AdiGD+3BsH0szTCO8aBAvba9Wz0gsMX9Uazh22JUjDP0ocUWdWK25Exea3r
         oC7qQDhWAtzbjiIPHSqEzormGS6MX6NwHB1FISASslA2byHNxVVsyRPo6/K0bXjBFtDa
         954/dvJ9muBIMEFZHbJ4259RBB9hGpDrN9JJFjwDqGGjXLi+ryIITyLDkEFcYno28290
         8sTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=recall.ai; s=google; t=1788200701; x=1788805501; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hbV5Wg8l0nJ8T1Mygha+CfNYcTHfR/M+eEDDy9eLWnc=;
        b=Hq2qGXtbf7CplIU2IjMssLrFTvcKBWgME4BJTcgksg3AmOaD6njspEu7ttZwbA4S/i
         R4yNpo4NIde5DyICVyh8K9PxfERKhb/6K3ZFalE/R1FIrlo2TM0GERtvzC2ZuGCwQmN4
         3ErNI92Yyope3tuNF2C0oMnIyNpTBSTgpS1oTqVL/znMNs2Bd9K+ogDM8yjlV2KL24SN
         WNc5+tQIvl3mWtHukyPl21/KjnqEhfnDxD60wxzLwqglrA0FRdPD3o44voDgPvmByKjG
         IzM9I6Ko2es8FRRzZWpo0Pepu8xx+jrJJQtBn1SRO16EKhNveX+7O9Y+0Kv37OWvf1tC
         58Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788200701; x=1788805501;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hbV5Wg8l0nJ8T1Mygha+CfNYcTHfR/M+eEDDy9eLWnc=;
        b=ax4ApQ9jHdLZKfLv6IFZB7i6z5CYXEXYuJJ9BL3WGB1ux/QEUL1eRGpdftIQrdNS8H
         XUp5md9cHh/nAgF0eK14ze0LOBoUQvWvTPGVm+GDrW3NFC3/CrFTRDfYWy7Q2/Q477k0
         C1aI3AoIk93WBxqv0ZDjJPsTelUOuRdRjPBQ02D1S2cQnmAProiId3IMxaMJHJ567VPJ
         BrpNWCctBZVzDroBWR7OmT6Di+68tAXjZjvWS982AMDNofIRWx1r+ymyqRqud0HfNjfI
         cdQyuYLwcFEwdgPuKaR0cx+V/DZLvZ/oM4O4EpWk7GjZSwDPwYh84i/qKn7rCfU8qDXM
         qrHQ==
X-Gm-Message-State: AFuF++mj5QO7Hx2ks4P+sUDypTba1HjXP+Rb3z7HaDgo9mqV0haxiWxc
	OM2pv0O3cH+r7WFYTG80zZKveynyVoZW4J9fNeCnX9Xt+Js4gXOuXbJWbJbrJ6qHynB7wJ3w8tl
	ODWReXP3S4qeYXTANQgTm+HUEkLPrPuvrRLiMovwmEwwQldYbnovn6DXfGE5s
X-Gm-Gg: AR+sD10aomwCi8Kn27LmnQC20v6EWW/QY5j5r9ae7tgBtiPV/4dWiHkpg6l/a8nzFOf
	2gzMwsirCO0YWc/IVyxrmvEk4IwSfF0NAu6rwSmbWiv0l+FvC6Pc0R5gQ0k2/HiCpANn6i+b5ha
	F2H4oswBs938J5Q3NuXCn8VTG4m3gVDKoEq4Y2hy4GOaN7SSAR1Ucg1FH/z6YXe8D7pMlCtZaO3
	WeIxbvEM+HN1cnTklCzD4NomCXha3UVjFZv26Rt7CaBFr0LlAXJK33lLTkDPwu+asuDcZAjKqUz
	DRhqGlfgli24xEikcV/5pGK1eYHow5fGfOfpQEqX1wb5hw==
X-Received: by 2002:a05:6a21:700d:b0:3d3:b00a:7082 with SMTP id
 adf61e73a8af0-3d3b00a77a9mr34040179637.28.1788200700253; Mon, 31 Aug 2026
 11:25:00 -0700 (PDT)
MIME-Version: 1.0
From: Mike Kaplinskiy <mike@recall.ai>
Date: Mon, 31 Aug 2026 11:24:48 -0700
X-Gm-Features: AcwNN1V4UKSJdBYkgpssMkmifC2j4_SqBsHSkI7X8KbOD1NWjz0zJyXnc6Ib_f0
Message-ID: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
Subject: [BUG/RFC] mm/madvise: MADV_WILLNEED skips swapped file-backed COW pages
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, 
	liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com
Content-Type: multipart/mixed; boundary="00000000000086d436065a5beb9a"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DF80140009
X-Stat-Signature: pkrjqekycsot4wpw86fwkzhj6yz7qdzu
X-HE-Tag: 1788200702-668843
X-HE-Meta: U2FsdGVkX1/X2F3YiJvP+5m0llURvbEqJuc/KxynMlk8X/RJ8c6+Soox768SHnSOpOxAnkJNnkZQA/DdfkOFGNVeh6MiZbQxEHHV18jlpnVua9xvaDSxPrMwZ7xCDnZfXM+YfBJy0bDGCGBu4bsuH26KzCyGVIz7KcMJbRyC6N69I72K+jpgk4U9mIaSg8uKtHLO4RMOW8CZVppenKxcE0O2EDMqHhJh8NNnZV2ildkj2S00SDPPGo7u6g2Q4WQ7CSkeGJrHN6gg3v5WyprNj/UMVl4k9UTeYvNgv1RDxh+9jmw2ktUx/SlZURG7yjLhObQK86je05mcYYn8xebRLPJPJNcHrlQIDLIfTAGRTmU6XywwKe+mrPf+VBtFc7PSeDNTq0Q7Ixovt6/routqcVSju7sqQLtLj3/StnDl8HT65jbFBMQqWC0GODLSHnyBPrSC/MaD2tqdGp7Vr56TDLa7zL+BXujzMNIrB+YPa2HdfWklmupRJGQfUZ9b8fs2AQzvTVXBLXBDxl53agblEIr1dlteE6VTsMR+YS+T4sPBpckds9/1AoCyvnWPXvbIzRic/K+IhGsEM54vJMpYuCF219pcPsyTRd5YUNtTOX8QlFNtJh6kCGMNfdb/3HPjwxEv0bOGob0dwbnh9DzmizJeSh/L/asOe7lAV76trI67AGZGlnPJ49QcPsY+kmmfY76W4NWCJwXuGlpjMoDMugSiDC9JMMuUe8mxxh0gzK9fVLNzrGLllPXGWbVoP4CKYQcUEfvFEsuj5X/Wwbbn8gdHafTjf3ZmqIm3ZSGUbpo9xbiCIYIo2LqpmgCcXcv74tMrcnzEVP4SaufMAFK65aWJ2A2HPiAE+8aaLw4FsirIyBQVBdCRgH0sQioYH+QXtUJX4Nk3RzSHZV4UVQl7wN6T4hGUw/Ib8tGmGs3owNTSPKP9pLcTanuKcomu+ybE+NSYg3M39pq+t43iPn6
 ZdmKdtrl
 eL24da6PW43OPYVuF13y1hi7ZWi+W8xo7ZLwrx3kjTzm7dyjgkPC35qhlULuTK9QmTsXRcFQvGg4/ulqrHTIcB5nkeNIFkx2WAvHjoXm6pFdQfff2v5PZdEcrXRhgJz5/WCW5rovHjiUXYj3JJ2SIP++J8qyt1Uc3hchBqUe0LHxS8KTOJbzUOqt46CIt02BiAMOMsRqL0BrvB+AdiQx/RGlQVaIFq3DD7IDBB4XVSrPds+KW9OnCP8C+nrJuk6f5oAjUgVKtc5JtvlBUlBvNMS8Yt+I2OvpY6Y9FpUqGjZRIvXqtjVRMc/8sIA47f+rkXfiQ6xIuNrFl6ZdiEEd6g+lkBPYyJ2xAhheJ7Kx7PEbU3LTPU++18MHhJxz9qvUJ4NkqTCua5Jb1GCzsm7vhejUsZpav0qCUYaN3mPnfa8KAshdqToofl/ylceisy5LP/EL/AH4FVfKgyEhNnSn7Mr2eXKZiH7fDGBYtNlJXXx7CN17GI/JRkRe+e6Sx6jbv67UH3ohLMCoaSrFvHeYaMQUHUejrZW1jfL5Ns2OnC92kiMgwqlCNr6HYMe9AJZjHkrsGmzkHB6Ean7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000086d436065a5beb9a
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm seeing a strange behavior when using MADV_WILLNEED to schedule
swap page-in. It seems MADV_WILLNEED does not schedule swap reads for
swapped-out COW pages in an ordinary file-backed MAP_PRIVATE mapping.

I reproduced this on Linux 7.0.14 on aarch64, but I think this code
hasn't changed in a while. mm/madvise.c:madvise_willneed walks swap
PTEs only when vma->vm_file is NULL, and sends other file-backed
mappings to vfs_fadvise(POSIX_FADV_WILLNEED). This skips the case of
MAP_PRIVATE mappings with changes, which frequently happens for
libraries/binaries with relocations and/or writable globals.

The code is at the top of
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/madvise.c#n282
.

Minimal reproducer attached. Would there be interest in changing this
path to prefetch private copies in addition to the readahead?

Thanks,
Mike

--00000000000086d436065a5beb9a
Content-Type: text/x-csrc; charset="US-ASCII"; name="madvise-willneed-cow-repro.c"
Content-Disposition: attachment; filename="madvise-willneed-cow-repro.c"
Content-Transfer-Encoding: base64
Content-ID: <>
X-Attachment-Id: 

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8YXNzZXJ0Lmg+CiNpbmNsdWRlIDxmY250bC5o
PgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5n
Lmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojZGVmaW5lIFNJ
WkUgKDY0VUwgPDwgMjApCgpzdGF0aWMgc2l6ZV90IHN3YXBfa2liKHZvaWQgKm1hcHBpbmcpCnsK
CUZJTEUgKmYgPSBmb3BlbigiL3Byb2Mvc2VsZi9zbWFwcyIsICJyIik7CgljaGFyIGxpbmVbMjU2
XSwgcGVybXNbNV07Cgl1bnNpZ25lZCBsb25nIHN0YXJ0LCBlbmQsIHZhbHVlID0gMDsKCWludCBv
dXJzID0gMDsKCglhc3NlcnQoZik7Cgl3aGlsZSAoZmdldHMobGluZSwgc2l6ZW9mKGxpbmUpLCBm
KSkgewoJCWlmIChzc2NhbmYobGluZSwgIiVseC0lbHggJTRzIiwgJnN0YXJ0LCAmZW5kLCBwZXJt
cykgPT0gMykKCQkJb3VycyA9IHN0YXJ0ID09ICh1bnNpZ25lZCBsb25nKW1hcHBpbmc7CgkJZWxz
ZSBpZiAob3VycyAmJiBzc2NhbmYobGluZSwgIlN3YXA6ICVsdSBrQiIsICZ2YWx1ZSkgPT0gMSkK
CQkJYnJlYWs7Cgl9CglmY2xvc2UoZik7CglyZXR1cm4gdmFsdWU7Cn0KCnN0YXRpYyB1bnNpZ25l
ZCBsb25nIHBzd3Bpbih2b2lkKQp7CglGSUxFICpmID0gZm9wZW4oIi9wcm9jL3Ztc3RhdCIsICJy
Iik7CgljaGFyIG5hbWVbMzJdOwoJdW5zaWduZWQgbG9uZyB2YWx1ZSA9IDA7CgoJYXNzZXJ0KGYp
OwoJd2hpbGUgKGZzY2FuZihmLCAiJTMxcyAlbHUiLCBuYW1lLCAmdmFsdWUpID09IDIpCgkJaWYg
KCFzdHJjbXAobmFtZSwgInBzd3BpbiIpKQoJCQlicmVhazsKCWZjbG9zZShmKTsKCXJldHVybiB2
YWx1ZTsKfQoKaW50IG1haW4odm9pZCkKewoJY2hhciBwYXRoW10gPSAiL3RtcC9tYWR2aXNlLWNv
dy1YWFhYWFgiOwoJaW50IGZkID0gbWtzdGVtcChwYXRoKTsKCWNoYXIgKnA7Cgl1bnNpZ25lZCBs
b25nIGJlZm9yZTsKCXZvbGF0aWxlIHVuc2lnbmVkIGxvbmcgc3VtID0gMDsKCglhc3NlcnQoZmQg
Pj0gMCAmJiAhZnRydW5jYXRlKGZkLCBTSVpFKSk7CglwID0gbW1hcChOVUxMLCBTSVpFLCBQUk9U
X1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfUFJJVkFURSwgZmQsIDApOwoJYXNzZXJ0KHAgIT0gTUFQ
X0ZBSUxFRCk7Cgl1bmxpbmsocGF0aCk7CgoJZm9yIChzaXplX3QgaSA9IDA7IGkgPCBTSVpFOyBp
ICs9IGdldHBhZ2VzaXplKCkpCgkJcFtpXSA9IGkgLyBnZXRwYWdlc2l6ZSgpICsgMTsgLyogY3Jl
YXRlIHByaXZhdGUgQ09XIHBhZ2VzICovCglhc3NlcnQoIW1hZHZpc2UocCwgU0laRSwgTUFEVl9Q
QUdFT1VUKSk7Cgl1c2xlZXAoNTAwMDAwKTsKCXByaW50ZigiYWZ0ZXIgUEFHRU9VVDogIFN3YXA9
JXp1IGtCXG4iLCBzd2FwX2tpYihwKSk7CgoJYmVmb3JlID0gcHN3cGluKCk7Cglhc3NlcnQoIW1h
ZHZpc2UocCwgU0laRSwgTUFEVl9XSUxMTkVFRCkpOwoJc2xlZXAoMik7IC8qIFdJTExORUVEIGlz
IGFzeW5jaHJvbm91cyAqLwoJcHJpbnRmKCJhZnRlciBXSUxMTkVFRDogU3dhcD0lenUga0IsIHBz
d3Bpbj0rJWx1XG4iLAoJICAgICAgIHN3YXBfa2liKHApLCBwc3dwaW4oKSAtIGJlZm9yZSk7CgoJ
YmVmb3JlID0gcHN3cGluKCk7Cglmb3IgKHNpemVfdCBpID0gMDsgaSA8IFNJWkU7IGkgKz0gZ2V0
cGFnZXNpemUoKSkKCQlzdW0gKz0gcFtpXTsKCXByaW50ZigiYWZ0ZXIgdG91Y2g6ICAgIHBzd3Bp
bj0rJWx1IChzdW09JWx1KVxuIiwKCSAgICAgICBwc3dwaW4oKSAtIGJlZm9yZSwgc3VtKTsKfQo=
--00000000000086d436065a5beb9a--

