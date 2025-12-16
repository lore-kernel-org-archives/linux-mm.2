Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A5DD5B874
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DC36B0088; Mon, 15 Dec 2025 19:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51C36B0089; Mon, 15 Dec 2025 19:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D3F6B008A; Mon, 15 Dec 2025 19:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCD436B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:13:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 865178A857
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:13:45 +0000 (UTC)
X-FDA: 84223410810.10.0366D20
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84230C000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:13:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uXTvOh5S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765844023; a=rsa-sha256;
	cv=pass;
	b=0293yDLjQNHgQPGVrm+vSQ14CHppaGI2xJ5IfeyoNAs+oj+lAeTcGInReFxHcS3QFzbtbv
	lEBghLpxD9/ioGrZtO6GZPviO2EVJM+lJMVdaTaEOXBSmdHee7VonxVPIN7k5LVHZHu48N
	/gFW3XwHiJ74xXVtiY4yQyGYpriTqIM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uXTvOh5S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
	b=lmEXYevBWLHKFxdnZx8Jq57IruwnLR/XBzNIdyLvXDTd8riDWqKSC6m4Lw35RZWT4KLb5i
	KL5OGiWWpw8n2IhPDZGUrRUykRf824azd5tLa+dOLj9It1qX0Wm16If/UnyWYzEweshm0u
	zaCGiNRBz9cymXu8hHdbUWs3Q9R4d1I=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d06cfa93so13315ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:13:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844022; cv=none;
        d=google.com; s=arc-20240605;
        b=Jr06THjX/93uxgQle4TCRaD3g9fX5GE/h78PPavuLB3ycIsf6Wc3+d9WIeEx2pYSZO
         3S96OExCD2HS8SzVIc7xLFgcBXkO3Tb4SD5K4dP4ORY9yfP5Cr6AqdfCvmq5cB5LI6JY
         T/aX2iNvGggh/rQLlrWNn7BUKEpl7Ui/VzTqeLv8km785PNtPAS6f2TecxH6G2DY0A2S
         HUOs+pUawXC31jYrIfpLFYI16dWRxm3Tdng0ZMvp7oyjz7/FkzPeFtfrWq9wR8O3xcC1
         R0lR3hyoDNN0l/GbCK+y/kGujjjQaG079FiJK+/1Iqi0aEv9Z4fJL7R/d1hy0m9rCrds
         gG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        fh=ZH3+3Em+Gxm24TaXzIXOecKW6HCBQbnRtALwCgE6QLs=;
        b=gOjv7ej2xVXrqDkFSTjJRidvi2CWq4F/HDJ6oWUONW+ZOS9EuWWlG50EjcrUHzWShR
         ClraQKh5Z5usS6ZUZqyHow8lScvx8NYXsnDnknW1rGmljnI4dv5jSvseLlVFBfn4QLs1
         8BzFMET1YTMEBVgBJAN1vBb+WWtaIkpLzrQuPIdpjNWhEu3/Mum6mGWuUpDerHVT44Nv
         dc6g3BNOUkB5ZfU5YGQeIaqDb+JgRFDuGDYl1UNC7miksuc+PDOze7EAk9IeRCpzRGfl
         o/37x0FSd2B/AzwGfqV6QsTAQ5ta170ZgVcOHYAdEwLgOG9t/DCt2SdjVyqZmP62jrH6
         /t4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844022; x=1766448822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        b=uXTvOh5Sw5Wo6/j/3L8kLUMdItp1H+BoZuHtXkTQP6qVaXHPVM+Ckfu6waQqdJzXdb
         NsEex3MddFXaJorfIwRvyMYzWG9Ht69V9w0gDE/MDiPRjSb6mdZWTauCX0zbk10bYhdy
         Skos/kaN9w/BouSDvDzTwiTkX0FFfr14JcyciaXDpXeB07XtdPyHf9gSnXboidl+8t8c
         HWpp6z+uXhib8MPNtO+fVDEqEF7ZKYbFvN5tY+VBqsMTU16yfb2bQfx+rX/GxWMptGn/
         mbw8kBH/SJSqDtkkpSTQvf3UdpW4n3QnNRN2dyc29AL7bS1/cfiv55avShTSKG/9kcHW
         QHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844022; x=1766448822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        b=w2eLfrtsMptE5R3p8KYLF3XcY6C0/Im6VgiaFvsW6vojKCAVLHmPR1E8mJUXS219tS
         qSYN0UH9o5XfOp/pPzoPPOYPJFbVRfMaHfhYg8sH/czxTJcIRAahyNoMPDRK2OM3HODo
         W6vC9H/iXZwCgX8Lqw4tc6piFouUrH03s8tGEo29CkXPOGzVn1caRdZV/KteeycmSUy/
         KGxtr5zmvbXRh4VQQVTWBDTLBRgSg0ULdy1lAFv66vanFiwcqpQt9Ucxwty+D9d5KvX9
         Mz2CMrEd02Uf4bGkzqw7n+LylB2ZGMoxdlqZ0WLzTGmzDckA3AK3aSFUxE7M0sOCPpHK
         kpLg==
X-Forwarded-Encrypted: i=1; AJvYcCWngGlKVsvkNf/kTVEYwfWMI6CPQcTKCNvTT7DnKDOheh5HhmFLFcbyCjt56JWbmLmrKxGJ114M0Q==@kvack.org
X-Gm-Message-State: AOJu0Ywf3zrgQ3GvTiGThhT1JfrzURU2mXOjuFrtWX9q6NlEhNB7QQip
	D7HT1Le5fnK6Yq1BK9gj1X9t9Qlr9diNKHqmM72/XBcGHIzX06k04Ttul5HWyNfCWU1qSGcxHXG
	7drQK5g2K8aIhtwp9ArQu2akdF4P27Dj3HCN9tMr961wmlZxGQGFX+WLK
X-Gm-Gg: AY/fxX6hP02FtUPX3YQLD1Gsa/7tcsAI5SzUSc/9aY6qL6XbmSGFHhSoDWhbZ2b/zcB
	66YVrsy+cJ+7K4peO3Aqo7f3G/XtH6Ww1s8eo9kljOYz+QnHQ8rzWLCG20GbRWt/oIYg176HkTG
	rhywPPr3WDJJp3k/J3hVge8g9bnOrddO0TVWvhqi5cGiRD7e8UDCRqtnkRhbepqgxzMVoH+PrNk
	1EGHTWhJ9RM74U9SsMdmHijsFqt/E51ySHbTVLDplUItzrNu3dNhBs3rK9pppuXiPejpjRoNj1f
	96lzsxgoaAcZuuzRoNLfPSVwFQgh
X-Google-Smtp-Source: AGHT+IFoirOvNMJpKn6tP51PRi96WA/WP8WHHlPJAFYlT/+WZt2BNZRZRHngFXZC5p9GdQCCqI5te5+CZ9A/FzrtBPg=
X-Received: by 2002:a05:7022:ef14:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12057217cb7mr94c88.14.1765844021847; Mon, 15 Dec 2025 16:13:41
 -0800 (PST)
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-3-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-3-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:13:29 -0800
X-Gm-Features: AQt7F2r7bucqAHi7gjHHb4xeDTJY1rA6zwbPyLTqR3xjOn4AhUq7dG2mlIrjznA
Message-ID: <CAGtprH_4K9TAH1DoeAW-UHTpMY2sNr8UUehoCPX_SKSQBNoERQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84230C000C
X-Stat-Signature: djjgg5dcgzq4g5m4djz8hkfyantq8szw
X-Rspam-User: 
X-HE-Tag: 1765844023-397082
X-HE-Meta: U2FsdGVkX1+M40Ow3ekCerBJY13Mw3zqzqpEn0mtEL1ggaOY/9Syo4EhcuyrikIZos08umVJum/S6L9kjJeeVuzd7+VkacsHYwD7HztTno/ewjYqSvhfcBySh2uAOAmZT2NsAjYE77LihGB9wf+ZoeZ2OYlFo8nhIdCUA3TT4zb22ANsh/DK9lW+GLZn9VBIThuXKKRVuaBp8LDEIyLgGLMBAuX88xsr3G+/8CKLrTcc76C7zKD0CLDrm4ORVEuZcQ7c58p0jQKxKDjtBvW/8GbKyjyffDTI/FXHhmLL0YbHUdvvA3BKZ6RADjoHrWg4eaqll1oExYiDIg6TvcEV63QVXgFfHDqoGf//1l1670ySoXOLn67tei8xbR94uPQ6wWxo2fr1q4WW9K6aPWr++JpRusjaCuK3u3QzMBpeuJHFDC++1//Bsqn9H2rqYY5PGQsb+8xB0MN8yvnVwD1ua068xUfuFBssaqtsFjlYZX6IHIdx/QlvMLzSJyUIBgrmim0pdBpfHY93eKEQFKDDUANLWmhgDF2s1q1pnAaePzNvXbz6mYw3PbHQHonTvk8sC/wgyoDu89ZxGR4dRRJSQLw+9h2Po32nPF2SGPUS6+trn9d1yVEh/qrBgnbwoXnFAuQS+g+owbcKznqes7i/h6ZF0yNF8303KuNeLZgzcRFzIBO0P1A2p87q3W4O5/jWF/UPC1AwnWnBCWqhhS7T8MHQdVyJPoUumTaYnOimyXo7c80qIN/3zSlTSad3ODhcWtUr2Oifcr9MC6u2Bgf1ZXfxPwRJVOaZ9MPMUqiG9jNVfrjBs38zyNeVO++DgDwINa3lUeGQsf6uPb2LnsMC7Ei2MSjoZ/IVy42wsGjXZZvZpeon6wXXtoK7ITh4GPgmPoBYmvScHO/IeX/OEZnRDIFeRH6BxyJIUkAM3Xf5ITeDahLfO1fi3SgIu1diUNCeYZ100NspvKg7XUciAGY
 27a09zpr
 vA6wUB1dj7lrxTUD6mrwVbxvqdPmQoWmAn/vRDrCTwggmCdQcoWMhtwFfA5mB59Xj0SUCUE5Ij8Dh4nHwz9DuWxsZuT0LxbWIt8WH1THF8blYeXTy1gNvphRx+1bN5og3Fv5QFYbpvbp3324akYh4xzNL6QP8hNtoyasjAYYulxZtkSEE2DloXKwcQse4gJxQW3+fK0b4+ytJKd//z9yBHeTqkyyIsTdHFtjU1ff/cGVcEJANZxs5CcP76iEdTSD9Pm76+hyiufwtVpA+9b85fxW5GPaxqrwcmLUKnGaWJZmqDrC/AI/RTdn/zMwfSiYtgLMolqQshzAV9Vc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page has been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-By: Vishal Annapurve <vannapurve@google.com>
Tested-By: Vishal Annapurve <vannapurve@google.com>

