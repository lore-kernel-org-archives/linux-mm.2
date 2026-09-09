Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D050C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D768B6B0093; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D269C6B0095; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A376B009B; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA826B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 146A4120215
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:45 +0000 (UTC)
X-FDA: 85194593610.13.0F76138
Received: from mail-qk2-f6.google.com (mail-qk2-f6.google.com [74.125.230.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FC49C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g2wRwfps;
	spf=pass (imf10.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.198 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967423;
	b=Ej9TEpnjwj8BxP2WIA//uuqIknQ38YspQ/J++LEYJfO1hQbAvN87PfoSMuM7lW4vp/PrMF
	Q91yJqKA4QnTO3IdfRSaMBQqCvaWDKwc6A+/IvsC9ihh8jTlcoL4oajnjCkAM1jCDigCsB
	2u0OLzSSCkdg772hcoezTiIZLKRd070=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g2wRwfps;
	spf=pass (imf10.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.198 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgR3+XPzaA4eb1yREhzJJQ+MQmEe+bNTZ5LaRJWFRUI=;
	b=YvjZEfKsTF6GC+rZ799fXI45PMX6yc1yRNJzvYHV6vMd2NJWQAUN50d77vOSRDmS/EB/L4
	rELOE6ZNSajtBKPVlRg3IfnWgvxd2p/+Skgh2jzDBGWzIjMb9XNCaHhW0WEH8ELPzn2gfs
	tmlbNVR+en2Vw/3REKvA4CwCSmYqYI4=
Received: by mail-qk2-f6.google.com with SMTP id d75a77b69052e-52fa263dd47so32008541cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967422; cv=none;
        d=google.com; s=arc-20260327;
        b=WoyZhtTvHtUMCwBEWBMlrAsR0XAGDVGfeB5RK90ReCE1Mugdc/MZklveRHDqecOznU
         j/FzkJ98dk1sTtwQ/avso7VFuKF45O3hmOrn3CN7EtKWYSDW0fBf9yxEhr58enViAKza
         dytFfMzehwqoMpDTZGwNlpkpQV0LCKY1z0q731VOQ3dfCshIbMMlpJhnoXsd+1/juaQp
         2CYGofY24IvLJWM2Z+VwtwPAZ21kw14GluAoASebN+a5bHusja3UFRvhyNy1WMRca8uc
         Xx5lEWEFEgu3kcMs6kzc1sequLPjxPf9Tl4W3IPmVxQ2z2CrgyrvICE1HA/ev+nfNJ27
         helw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=fgR3+XPzaA4eb1yREhzJJQ+MQmEe+bNTZ5LaRJWFRUI=;
        fh=JvucXwbPVKsLro3MvEYhiolT16GnM4ycpmeVDrf7VQ8=;
        b=q6a5LZU9S97b4HZYAy1qxmQn1XPItqO/wx4+m60UPfa4cstwXnZG5IQxvDU49aqGXS
         dp8lnNn0vu8UAMX4eacDv5Uj+YnV6hvyIfB+a+P3vN/oxX6vFpGibC37SZETVrAgtWkg
         2ci7zzUhP4v4/3N4JpxxsvmcKyLRRfu/yrGWu9CpJF19LctY3+fjx/UezKxmqPrxZMiG
         vne5JUhfsn1A1JfNt3K6Gel2w56HJpm80t80tCrPgXUbptxOY0Tvgbn7QvQxRp0WgVMm
         ksicj5+8PZTebvKUMkmEEU1RbpIyHHZcTagMUMiz1GbosmLQGYd3KqUESj9rCJBnOL9l
         LP0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788967422; x=1789572222; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgR3+XPzaA4eb1yREhzJJQ+MQmEe+bNTZ5LaRJWFRUI=;
        b=g2wRwfps/CUP33kvkJye3lXRdMMhRRzV7DeDG62h4rBoifsWckYVPX0TWeeiftVmtD
         Pls6A3i5a9eb5A5TgWqmQqh0YIH44/ISvNznk9qXK+QTERNmPvytsxjEGKZZO2jjFMr3
         +m5icEQ5/jnjWu6f7Lv16rsMR4jHNIKmiIBI1QU5sa4pUX/YdABK5WkjTnZM9phVmCM/
         HHIYEA8QoKhZ6nYlzuzkPKA8ICfv8X8phDZ985bz2deTFXhHzciNo0w9E6ubYw+Oi5po
         h0RkYdZU/166b236qxVqhBm0P9KLw9f/H8V9Kz31LDOyzw1lU1L7Mdg2hR6GjcpWLVGD
         jiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967422; x=1789572222;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fgR3+XPzaA4eb1yREhzJJQ+MQmEe+bNTZ5LaRJWFRUI=;
        b=j8c/c2zblE0XQgEtzSB5oYCbTanWehqk6O2EvbjQ/pkpMMksNDrMBvD1WM+xqZkIpC
         7+HMN23kiT6V3iRGgiPX6Rp2M0oD+2XKYkEcdFP7VArKBdk2bm+cPdlGbpo3GXaTEj1s
         165Nk51NDX1W9ZE58bFXAXW6El5QhQ/eOWZv6Vkh506Q+gzc3W8Xcjr0JR8USfQ35bZr
         QOmwPW0ocmXkGIxD3sSaZ4albuwHNJbmHnM7qlYIBJShF3u8s6mGNzGWHfwwUb5GczY4
         +az90ypp61FSzKO1npnUOzrEz+iwX5jHZ8Ul5QWiXmwclnqYLvqYVMiRwgC2lYKGqWhb
         aLFQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1vRQIPGIu/IqlkUPHnJ8zpks2co954BjA7wXncL2PUqpiMMOhGCNAC6+SKE9l3b0KaSdLusc5gQ==@kvack.org
X-Gm-Message-State: AFuF++l9Wiziq4BYmyUF4EseGaWCxkO97JljwF8pg74kkNbEhXvNxiEx
	M06VnN2H6BlfUoVCEQs1gvI/5qinuT4ufNuoXzRtMPGJ3V5Mdxd9idK+UhegKGdZboJoHYtk5z2
	y8CNscBXwp/hRxetyZgmwoCoa1FsBFCc=
X-Gm-Gg: AYBFou037HXw0K47eC8kRZ3aavS5QxVNBOLyxxyqoi9D8Cj2HuoY+oNIMJgKv903lRm
	PH+4n6CL+MDGek5J1WMRpDrTMrkpfOc/hcKW4UH5heRnLHg3iTyCmeWENg8oj0Hue9SoitsHZww
	rRwdzA2uu4avUF1RShoIWHUMXzRq+4GQE2e7ryx0ZTtnP+wtE7ysTBROTXxdiA14qaHTxOOjjg+
	t7umRJSlg9GipNivu5zkP2NRcpcu51iosuVF3eupv3ONhA/vum858FeaJkMz8vTUld1TeoqpXAM
	S3QHsLWAAaI+jBTRkxKrSRBbmMrsiwIwgKQVdsEq83VYlTuKuplF4Q==
X-Received: by 2002:a05:6214:40a:b0:910:4a86:5975 with SMTP id
 6a1803df08f44-9104a865dafmr350346336d6.29.1788967421968; Wed, 09 Sep 2026
 08:23:41 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:41 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:41 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
References: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
Date: Wed, 9 Sep 2026 08:23:41 -0700
X-Gm-Features: AcwNN1Xs_Ic-TFWEWYafDXq-QgNp-3x50hyH1ZaRfp2J0FhUBBGeyv5j7fMk6x0
Message-ID: <CACGbirT2U3gCWcYSTVTZrf2xey_D8H-s3oE8h2WW0YrDTV_Yqg@mail.gmail.com>
Subject: [PATCH RESEND v3 2/2] selftests/mm: Only prepare ptrace_scope when
 memfd_secret is selected
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b3b768065b0e6fc9"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FC49C0004
X-Rspam-User: 
X-Stat-Signature: eewjrjy819bxo5kysgd9inpknrb6o1xg
X-HE-Tag: 1788967422-507116
X-HE-Meta: U2FsdGVkX1+KrycoyUiL8Tgfh//ugH7b4SrS/SmDg5GuU/ynS/J+M3yaK5+mojTnw3dWxHfZYEeBwOwnlBNqAMI+Et+NXSkTDK6DLbAZMu0J6D6Wn+WxHpUZB2g2Us25xL9fiEWK50Q7Y/oAqJeGqdjbeLDM8PTKvn0quECxA0Jjb5JZ4msOI+fuXaXo5OxOMKhZUzMgM/DEER7FJSkSgWhm2jREkczCg2tSi1+LvSxNxq8PDy6rZbHcTYHnbZ3CGjmTV6gUNypNkvt33j71hLpUMlXipBGVHYRVLth3/cUjGEStShSvOKhezvrZmZtwn58v4JVeLo2CCCn57zopHBkvMx4GSezbkyUWaa27wx6SvuEw9hSZ33rhTbbO8eV8j+q1soCg/y1qXqW2NZQsbicYDc8NUko7t6u+cPif/P3p7AqXTOwHz8cGrON7hSlbzY6O1E2S/LxlyeGpXa0EM/Jvhh11IxkvmpsWXdJZahsN5aacqaIjsIrUdr9tTcgztbt0K05sMQJjtgayTW+xPy8ggf2qefk9t2zzdA7ixTf+CtVQsf5RY5o+oj5y5+tNFkb73Mfpfj+mXhn5Iswxnpzdmwd2xFO/OuP0XrEBJiuM53RIZtyRB7nwgnad1w5ZVQszgFn2gYBSfP+ybGfFvMQpoW8GO3NOG7wCGSBU51FqFMy1hnT9whaUKDFSmk/tbzdG3E95215L6yMpF7tSzpOeEaZz67fQ90BeuKnDuQAU6IDWe86oGi4cxNjxMVwKG4kpALiYFsvkNlYqeyK0LwoM1pdEqnT13O+lZZmk6ioTSvrOvG8iTaaeuik1GRV2gRx1dvc7isUW1ozoJ6wwn685aSW4HWDWJGxRHFmpN1U2AQ8GA2kcypneASMzIMOlfECudDq1h8C3Rqx9oIS/gW3TU1Mu58rcXTuVKI58XrqJpkgIy0dRZUzb7Ktu0PdW87utwmkzyyVqCDwE4xP
 szC53uV7
 NQSAocwxqYsut4Yh59j1mQLCj/WxV1GOMxiUGygJ7JOf/catcPlts2QMGNW6r5HTzimwlc99tpWGSmBbTZsGyeEJ4odXcBXCg8UVOg7e26M3EZEo+MJwj4kpUdD9KVDKe6pbRvq30f+lk/7cvskKkSw3COLatX8O+GEhiaEVPivXHAc0ftXNUY41myT06Co99sXtsCBrnqP/y0lkzw4Oztt/sbVTAKvkRwYeKYhy4lUdQ+AiLJxXkfiMhHQuIVS9Vua6wkc0AUO14Gjo7E7nMFQMozdWh73/PuXPVsMXWt87SnvnRDblm/tNjxTDxHqj5mlRoACH1khPYt0Fa2Ex1yknRgoy3L6dhbo6ZM9rDUuwH4HuiM87jiDeEopH+0kiEva/G/cvgx4Ttk2wRm/2Bb/AEKEUoHABp4BlJmE8SjUOX4L65yKCHNJkxWX4DfL/MK0j0NCk/a1rsyhm3n8YhY9nXLtqyLxY/1LDWjEFDwARuYwP0ltJM+1kLYnHSay/dP+s+3EM6vYaVoOh18/1jFs/Wiej5pY4pReAiwyt4bTdQraymxptEZdjDGJKREnzZ7uU7f+1EekfT+Ah7j8Rc3Ey8sA+8SWBhMvprHUjbKEnHM83PGPzkLJ4468y22x9E31JwrTOXXF88Oo5iBWYeGgsZPzXIyEaUGbivmIfxXbryfP9GuGHCdUnU5p3Nw38UajnBGX3Rbo+CyhMa61xOTx8KUYcatQxuKD+6NrLu12dGOHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000b3b768065b0e6fc9
Content-Type: text/plain; charset="UTF-8"

The unchanged patch is attached as text/plain to preserve long lines
and whitespace during mail delivery.

--000000000000b3b768065b0e6fc9
Content-Type: text/plain; charset="us-ascii"; name="mm_patch2.patch"
Content-Disposition: attachment; filename="mm_patch2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 8474edae0c98aec2_0.1

RnJvbTogVGlhbnlpIENoZW4gPGhpQHR5Y2hlbi5jYz4KRGF0ZTogVHVlLCAwOCBTZXAgMjAyNiAx
MToyMTo1MCArMDgwMAoKVGhlIG1lbWZkX3NlY3JldCBzZXR1cCBjbGVhcnMgcHRyYWNlX3Njb3Bl
IHdoZW5ldmVyIGl0cyB0ZXN0IGJpbmFyeSBpcwpleGVjdXRhYmxlLCBldmVuIHdoZW4gYSBkaWZm
ZXJlbnQgY2F0ZWdvcnkgd2FzIHNlbGVjdGVkLiBydW5fdGVzdCgpIGZpbHRlcnMKdGhlIHRlc3Qg
aW52b2NhdGlvbiwgYnV0IGl0IGRvZXMgbm90IHByb3RlY3QgdGhlIHByZWNlZGluZyBzZXR1cC4K
CkNoZWNrIHRoZSBjYXRlZ29yeSBzZWxlY3Rpb24gYmVmb3JlIGVudGVyaW5nIHRoZSBtZW1mZF9z
ZWNyZXQgYmxvY2sgc28KcnVubmluZyB1bnJlbGF0ZWQgY2F0ZWdvcmllcyBkb2VzIG5vdCBjaGFu
Z2UgcHRyYWNlX3Njb3BlLiBLZWVwIHRoZQpleGlzdGluZyBleGVjdXRhYmxlIGNoZWNrIGFuZCB0
aGUgYmVoYXZpb3Igd2hlbiBtZW1mZF9zZWNyZXQgaXMgc2VsZWN0ZWQuCgpBY2tlZC1ieTogRGF2
aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRhdmlkQGtlcm5lbC5vcmc+CkFzc2lzdGVkLWJ5OiBMTE0K
U2lnbmVkLW9mZi1ieTogVGlhbnlpIENoZW4gPGhpQHR5Y2hlbi5jYz4KLS0tCiB0b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9tbS9ydW5fdm10ZXN0cy5zaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbW0v
cnVuX3ZtdGVzdHMuc2gKaW5kZXggOWU2MmFiNGM2Nzc1Li45YmJlZjk0MTBjY2MgMTAwNzU1Ci0t
LSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoCisrKyBiL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoCkBAIC0zNzAsNyArMzcwLDcgQEAg
Q0FURUdPUlk9InByb2Nlc3NfbWFkdiIgcnVuX3Rlc3QgLi9wcm9jZXNzX21hZHYKIAogQ0FURUdP
Ulk9InZtYV9tZXJnZSIgcnVuX3Rlc3QgLi9tZXJnZQogCi1pZiBbIC14IC4vbWVtZmRfc2VjcmV0
IF0KK2lmIHRlc3Rfc2VsZWN0ZWQgIm1lbWZkX3NlY3JldCIgJiYgWyAteCAuL21lbWZkX3NlY3Jl
dCBdCiB0aGVuCiBpZiBbIC1mIC9wcm9jL3N5cy9rZXJuZWwveWFtYS9wdHJhY2Vfc2NvcGUgXTsg
dGhlbgogCShlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL3lhbWEvcHRyYWNlX3Njb3BlIDI+JjEp
IHwgdGFwX3ByZWZpeAo=
--000000000000b3b768065b0e6fc9--

