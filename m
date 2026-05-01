Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0908CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9A76B00A0; Fri,  1 May 2026 15:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AF26B00A6; Fri,  1 May 2026 15:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049466B00A7; Fri,  1 May 2026 15:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4B586B00A0
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:26:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94FD3C0F47
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:26:21 +0000 (UTC)
X-FDA: 84719832162.06.0750794
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6608C000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:26:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CBXEYRTb;
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwrRe7uvgwGdzqZZIxzZMY7X+HdKy+NM0k54UgSLbXs=;
	b=AUc/fVZm5xdPZ2J2NHpu5YnzpBP3M/1o5/KAiCy/9cCrgRojYhkrwl7M6nbqiKLFJFRCvU
	kRgwJjvddNt41J6sPDVEqZ8PXi7t+e7TJwFCzmUqm4SPBi5TRNVMhkninCU3IRl7M8GvSh
	vW74M1d4X7RKmPwtZZwYI5lhb7ChKYA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777663579; a=rsa-sha256;
	cv=pass;
	b=t9jCLuTmPPfz7DX01Zkcah7OzzXkVV9LlE0oet6rVbcks8UHoHlQrfu91WvzmeuukamiUQ
	T9pR/H9+5T6AnrCNCQ/YEMVy0glf0MMr4wJ2SYJ+l7L7fBwD5dhCWTAmZNOLKGhJyKgfPJ
	6Ncbz7OtJwYFL75/RFYFwcG2f+o1xpY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CBXEYRTb;
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40427db1300so1614220fac.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:26:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777663578; cv=none;
        d=google.com; s=arc-20240605;
        b=gUfIiJvWL+p4DFu4/ooonzu2pNXf1KBgZF9Q7eX6V0RJxx58b3dFPl/ck+ow41q3gk
         lZpn27whljAo89jTNhHAMvHSm4EnUWtdTbAcWBftn0zOnmKV7GOc4uLAnnTOdV55Fep5
         DdQjSsM9RoviWOqdo4QaLmTmKdkFcLc3XrMSAlf+KJmtP+BF259jb9u/yoWWE/eJsBUI
         xIQO/i1ZqenkfJk0w0Tfqd/UDD+p7TkKUMi1xThMLAxpKdxekxO0pBngbJ3qcmMYrIcM
         wE792pKyC/x/W2JjtTiM9U+ENoHVJ8Ekg/0eXaQAnrQ4E/YrfEZRg/fKx690FGT8ZjWY
         vggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fwrRe7uvgwGdzqZZIxzZMY7X+HdKy+NM0k54UgSLbXs=;
        fh=GVGMuf83UNSGxxpdxr2JtJjGVfq4ELmZjAK8Fp5cXis=;
        b=a7th3NDGnRe/qjZ+hsDcHg3C2le6rOXbdUn5OrX2QzeWxwe3BcB9+mwQAfn8kYoq9K
         YvMrmg/wGLgkVmPouumDDgv93hBGqBft3/gZGxzV1Y2bUzQQ+577JVd9Wn4FJ6t3hP9/
         mktm/1TI7fdRQ6IHvaE1jt8g5e5c34LaWwvHnfpKHjL8qVDGArqAR+kWUTr1MBFMRnjd
         3pd8APrQFl2Md/KZ0an0VcUjCFwPphuo8ZWVQkOjUHGzkYJZhch/xxkhRyRhwVk6SXnE
         aO6DHlWq0iEK2bq5rOkVTzPqCdoE7h7Nw5UjCYUamVoU8V/xlpFxjVzpC2i1TnPoEaTL
         SYEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777663578; x=1778268378; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fwrRe7uvgwGdzqZZIxzZMY7X+HdKy+NM0k54UgSLbXs=;
        b=CBXEYRTbMh2i9Dyg8MzS35vNpm6CTKQ/wlk0q/0f2nmr8tE4lWFbWGmL7K1gP/Gqun
         HHAQAug2c+rhQLtWiQKDJVjgpU8LdzeOVT2iM95RY0HT8KhEsrziXIqEgiF0TORGgBMk
         Tikzrg0i5APeblDnLrr+9qBS9rwwzoDNqDpMsoe5lkvWFb1S7qsCXpEDUp+0k8yiziMZ
         kTrRPC/illGkHl7VX9doooxzl2QB+UNjOZEScMj07oNgNFDN5puhy7rMaTpnONgOr9dG
         BCmp+t8rw5ZuIHNvVz8tn5DlRsrjHkE7tI82ufQs/gscWvrf+YN1zQL7nHcsMHgNxo2v
         SgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777663578; x=1778268378;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwrRe7uvgwGdzqZZIxzZMY7X+HdKy+NM0k54UgSLbXs=;
        b=hbIDiPtmvC+akc/hgtNbh1C5Vucea6Ly9ygjqV1/OQXtLHL4N5YIsDu3SP4cDO+vfU
         bDjQQOmkOaB5IBi9zbbmDwJcvKj6vhSNTB6Uk7xmpoefZqqLWkKBFFJcr6E+/Jde9Vig
         c2CjHZl7MFJ6qP7t6uwZEuGRWUkcqc9c8SifGfyxK0TcPh1RdrIYNkllkCMNT0sXbC++
         gMzIe+l1ePO0/pcMrIxsrfJDGr1fgGlrXGew3aK4p/VuNC92yKVpBHZspKHyaWu9+eDf
         Dpl3D/Iux4DIkOWm8uPLw24I8iiqFsZYs84AgXYkKhUwqhJS+caG5K+S4L0sBqS9plyH
         nPRw==
X-Forwarded-Encrypted: i=1; AFNElJ9q70+nCQSLSueztBpd4/xCHFFGpUXc1SeZ1iYPvkqQee2tEcufdp5UmlPVTM+OrdBHyGshxWRwFw==@kvack.org
X-Gm-Message-State: AOJu0YyWMV5dCxb8bw3djLeJ42JwiZ6DhwHUmbCXkz/HV4+G2LVsVeyN
	It1fnOvASNSadP9Suq5GHv8Yj21R2Eadiu3f2LHUZT7vDGnqTFzdm+vMgKtQ0tfuUDpZJ5eb7WB
	FppEM51qhDzyomP1ZWCAe2W+8tEWiHrw=
X-Gm-Gg: AeBDiet8FlFBhRq2yuHzmzoNxHUewdeOoaRlkNqBsrqj7hgzh+AldNc9P3bwvdH8oYF
	a9N9C2pwWx3ZDIUUe+eP/JMBy/ztSIt3h0Tv9MIwUMZE0yz6dx3F2bB7YJWeU+47AOvN4mWkg8R
	w+qnKeBaQKz+30LH14yhiZz2Xg8Pa9bYCidt6pAnIGKbKbTFrG9OvdnDC95oHkDclwixY/evA6q
	V+sasf4Z4bO8o/hUbvXPYzFtjOjn15DRSoO6sT1hjpJThY0pbM506csdei+afVhnIKQww8M1JuJ
	BKpCMX2ZyLdYCmTefJ4KFI82SNqdcgdCLRW+Yn8Nylb222i8
X-Received: by 2002:a05:6870:e18d:b0:424:5b7:65e2 with SMTP id
 586e51a60fabf-434762bc733mr616896fac.39.1777663578407; Fri, 01 May 2026
 12:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260423125648.152113-1-devnexen@gmail.com> <afT3no4OkYxnQ6zJ@plex>
In-Reply-To: <afT3no4OkYxnQ6zJ@plex>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 1 May 2026 20:26:07 +0100
X-Gm-Features: AVHnY4J-V7FULhfCx0jIPKVwi735AFy0QxrLOntts2ALdgLZR6Gq853Ejpr_kS8
Message-ID: <CA+XhMqws+mudAQo4ibaLb9MJv7pKDfLUAH8CcHSAkLNdPtijeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/memfd_luo: reject memfds whose page count exceeds UINT_MAX
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, pratyush@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6608C000E
X-Rspam-User: 
X-Stat-Signature: yxmzafjkzhr977c87mbt7g9ipb83ezmw
X-HE-Tag: 1777663579-832985
X-HE-Meta: U2FsdGVkX1/PR7z2Po/fUXYznc1w46YcbXnQimYwQirjPnjRhgsXQ0lJNNdrylMND4NrsAda3LH1IGZC++lLh6WASS8ca0EyEGxx3OkXSIthCQkF8kvd2nrq9j2Z5+X/ETmI4DZPJ9kjEsS3RSJ6ssD+32ZjreS/4dWMwyhyzDGlR/TCp551V6hU1GJa7NSU4MTAO9oihkbWj1FI7YVlVYmKo2dvPNi4F8AIq5fXzbIm7HbO3WHU6d9FyuPeih58E75v/CDwSN0xjNchDgpNV8bncP6zs0uXn8+OQRPzYB56VY1iaM3JS28MFveLD/OoFdh4kM8HD9pf6FYcBHCof7PuXrn3bo3kkgXb5bJTz1dXunAskuelOXWC271zK6vE1cEujVsX2Z3XAKiMar+e2uK+dEVylsMXfpqLUhnAhQn50X11NByWWSlPtlj16q6thkOURTx8HLPF7iZ8+6bc0q0adK0bQb65NgVbGZ4BY0OwlKQjAGIoDH5bbrqQTn61Ak97UwsROpMwL03pt8gza9jDKJOCFv6kxHNMtIiwbLtLokTCB88lncPHx8n3jMl9rw64+cX24EvbgR4/+qTBymc0gxaX1PuJ0G+vleJho3MgQAXnuvZ87nfwpCbsnwZcGUNjCWSSuXi9MWChDUjZEEG3aKcENve2nVqkchXt8Q45U5sWK4yoexOMX2M+zsJUEIHQ4YOTMe08rKuwc4r2tRL+vqkphVDVHgt/oG7/uAH6fSUUwghFxR8uErDCN8/Xu+AjDXrMgyzMiMnTbN78ctcc9Y+X1b750oQdd5I05CCoONaw5o8/mjQUNN2I3w4O3VAwPyhMfiIHEPzpm7xIB7Tg2M9Rm4vGTV21IxgaimQ7i0iy7YFj2S5U077pzax76gZHY808I/DLSjTlvIW1UJ24Ik5fT7ZsqSA/uu/T5zhakXRu1IYEQP0xFzOrtv4iWNtlqUJUxLMPHej79vs
 AKm3FdaQ
 pBrFHCcIlH6Iej14EMEO8CxZoONtxA86mndsJkCiq9n9zEXpDnYUZlkowT9xiXrYcQZ4vjmIsuwvT5heXuEXbjEc12UPgIrcsfnaqe9wNcT8QFi0qe813HndSY34kg7h/CQ4DSsxCb0Mrrm5wpxX6sqZItfHtJrvAKeOs5wDazPl9l5xARqsR7XtUIO0ZC16b/TIrRgBp/bzl0lJQ5/KjCDxmEdG4oTdeepXsUXJW1VmNT47T4QjbmL9xgU+1I/tyF7dmnUAzG4GOTUAhm4tvavg4K6EWgx3oVKJkHHGBlddbBG98mPxcy23P80eyv7zcKl5gslLnNDW6UkMXskOHQDpATNIEmibmpwUxa4gw6kaQmn9+I0JIxy4vpsee/MrTCfGQU/rANtDt0irWY2WdFh3s5kk06U7AFYrBXHC7EmDspJqyaX/3bzpjLvF/ZalvtKRp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 18:59, Pasha Tatashin wrote:
  > I think, the fix should be first done at memfd_pin_folios() to
change
  > max_folios to 'long' or 'unsigned long', and then just updated
  > memfd_luo.c to match.

  Even with memfd_pin_folios() widened, memfd_luo_preserve_folios()
still
  kvmalloc_objs()s the folios array up front -- at UINT_MAX entries
that's
  already ~32 GiB of pointer array, which won't realistically succeed.
So
  the guard here still makes sense, just on allocation grounds rather than
  interface truncation.

  Happy to widen memfd_pin_folios() as a separate patch, but I'd keep
the
  -EFBIG check regardless. Or did you have a different shape in mind?

Cheers.

