Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E632CC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D9C6B0088; Sat, 29 Aug 2026 13:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944EA6B008A; Sat, 29 Aug 2026 13:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882886B008C; Sat, 29 Aug 2026 13:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE906B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:47:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDDA8A2D5F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:47:36 +0000 (UTC)
X-FDA: 85155039312.01.014C560
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89B85C0007
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:47:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Yb+cY39J;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788025655;
	b=RJEtUkV7ygHDeLGE3DHSQziFkO2z5AfW4g86+sarHWBbqmHQuQJk61RCmzlyURaQxepS1w
	HRFgtMD8z8QKd/eFXtld8EqwNFlMrVptAL4/aS1eBR5G8hhEOp5B0PwfBUrMJ9CdGnGyRv
	qCIckHYGEp771t4zPhfUppCy/6c2FgE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Yb+cY39J;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788025655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/Fkaccw9B2NNKMBP0JXWptT1XXIEIi6C2kYt98ic7Q=;
	b=CjijEVObIBuF+3Hak78nfNc3YiwfwTJ8jclAl+1rtIrLV3DP7nqwVnVsQI2DxNXfE9k+1p
	nQaBOdoNVjBUWHNetPhvkUsu6nubuOS3o0RxgjqF8PyfaBISaGRuZKOBy+tkHUTnFfLGdq
	h/Eh9lOahNgcTsWydLPo7TZNhIK+Gp8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4451040E0386;
	Sat, 29 Aug 2026 17:47:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Pk3SwPdkSou1; Sat, 29 Aug 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788025640; bh=a/Fkaccw9B2NNKMBP0JXWptT1XXIEIi6C2kYt98ic7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yb+cY39JXT9OLBpECQxPOLbnSFWZ0MqAkTB9i44u1KU3K4urwEeBXcTF4+VTo2qE+
	 eYI/e3IruiOjfB/CsIIVoGn43ArbvsiD3x7YjjPW6mWvKQQepItC5oK1LQqYhoQZ1e
	 5GJ4FufqH5pR8YVUPJIoYUz8dGAv/v8Yf5P+ZWRlN36x9bvTIld4dGnFOgguSWirfc
	 QVnIommyiC6DcgdYIv28IF86v6NIb6ZKXmW0xPacKl122199vrBKB83OQPjRtX9VyQ
	 AF+tddUS3+o0hzGzyk2HIM8qtXfUqcAr0hNdbisFjAXCdtklnX5kJ9wB5kG+ZaSrQT
	 iqxCLjS4mJ2BwMh3GDXJZGA9/dPvRhGkIl+3jcbIiAFpr7AliJv6i5GVdCs3ym/Vhx
	 ElT0/Z1A09tFX+/RG+pNfxJT5iBAljaX2cYh3fHkroUyfcfCh9AzdPggvU0foHxWG+
	 Tsd9U4Hf0iasl23CCdKbDe8ofzr65pzGgimLtpKjbIB18yXJjmOoxL5wAIBoBXssgq
	 cOI8wuIocNklbT4Ww//Gh+/82frNeuMikkt/ERCuRtWJhJUAyoC3rz7IZI4IQpp+Yz
	 05QyaLOKE25xWlxWY8sHQFc4mTz34wzuVsNqZFdjbtSYZZDbpopYe2qPsYQrkWY5DS
	 tS3h6OpCPoXcY0YCsghPypR4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9A52040E0377;
	Sat, 29 Aug 2026 17:47:07 +0000 (UTC)
Date: Sat, 29 Aug 2026 10:47:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
Message-ID: <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
X-Rspam-User: 
X-Stat-Signature: 5pe98crd41gbpoix4y33zengp7rbhh3n
X-Rspamd-Queue-Id: 89B85C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788025654-562661
X-HE-Meta: U2FsdGVkX1+EDnSXGjVshe6RAAAOouKeEDLpOfBY9QNUfVBKmrQqM60ZjIMwWBZej8xJqeQOk5pDDfTNVOv/5JzmtAE/fO7MdXmuNCFUEBlxxSmHL83xEu9125ApOSNsqnuD/qSH7UYjGLB1AnL6IIPGBd7VvryA+djPYuZgbY+S1YOE/Ok3t/twIkzo7ytXrl81OZ/uAKM6BF3VJ/SxGdjBHMBqkpqIxekElMoSF3kVCYyIS870pHRgkvZUwniwW0lzJTxhnP1LePQeyxZyPczWD52zZXEMaXOtAMuA34VgAuBYZEd1GRJgQEOfNBKdb6OXVv0mwE2zsmRetR/dRtVIphxTq7SaG5O9lxOJzZxLFD8QbM9yDaIr9pTJc3nEifBM9tqF+l9rM6wuZr2kO3vy4SMgtGcjKxfmsEVMsMHV2C0XruzIdylB+YIl6LJMH4c3XHgEUdHbugs1TbfnUc8wh9P9F+Ex3SwYWxQTt8/5ZLkdgQgcQLny0NpsHGamqhYLPfp3rnxK8u2s9fDMj5yZJc7E2axcmRFifiALwco0LvuyhJ0Y1+karo32t6wJOaAXsSuILYzY+egqguAYhuGXXw9LGD924bxrIlLxAzWILYH6mFczHQx8h+vD0CUXBTVgJSv7XfrDqHsymzTumTV9g1kfe5YjmgA3O5lDKADmQ6d0Al7lJNlOSVw12oWhj+Cnh3cp8v8Gms/9nQbJeoKtUWQs/vJulEtQwHdulPi7Rdu6ztUyZs0Fxele6xPVNI7MjQUKtMTUrNRgn99L5z6auSZS15vZiI43qiMf4dXRTlE9amCXYwZs1n06ahJenG1E0wibTQV+3mMbcTTM7tiYQta0+zIeH3MG8Q/LvzE8npmrtiqvzaEbBmCux8p8OOuZAloKRV3fY/8+Un559UuCwfxXD2lg8gR90wx1qlLcQ+CTWiADzwbisfpv8LR2gfDQIwFwqH1Tbv1NvcY
 P9EvDFme
 u8FW9i35728aDduiug99Ll3rntDNjqayzePYhYtJeifDejdJJWWg4bxNP1nWn0XJnxKFGAHUkuqRJDeYaQoUaL4O5bQ7TzygwEH9iKjSBb83eiYMAGrgxeV1jsl5K8vZLOnMwrufaQpCZKr/FPYDNidAPZuKZDa+eE7kEwDh5d1oAI3L6RqyUxy64S234BbDKYX4W1rrPDGNOw3AVtNZwV2hXGs+NGrZu3328ITwL/smnZ/h16njAdi/0GjM36QfH72Fbj3h7CKGIpYQ89QOKF2rYdkjs6zsllweQEFc94MgTS1lSQp2/C9wB0+zwNmv+hQVf80LJLaJuN4ZpY/LzSKmNQn/teHnwSg3J+6pnfO+vDJHhIU1JUcnpVlvnKUvSMBfgW4xHjJsOopgMLXsnHQH1q4VDF9C6KbXpmLg+aHu03mY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:07:42AM -0700, Dave Hansen wrote:
> These AMD F15h CPUs are, what, 15 years old now? How bad of a
> performance hit *was* this issue? Is this optimization worth keeping around?

Oh, look, even back then I did perf measurements:

https://lore.kernel.org/all/1312550110-24160-2-git-send-email-bp@amd64.org/T/#m04c05a9a6f59b73d610b556f1efda8cd9e0487d1

8s penalty for kernel build workload on 3.0.

Do I care about Bulldozer?

Meh, I only have access to a laptop with that uarch and I've been using it
only to test kernels on it so, not really. Besides, we have Zens now which
are soo much better in every aspect so that Bulldozer looks more like a energy
waste than anything else.

But there are apparently folks which still use those and run new kernels on
them so we probably can't axe it off yet...

Looking on the bright side, Laurent can test patches ... :-P

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

