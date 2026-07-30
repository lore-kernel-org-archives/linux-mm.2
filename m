Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA489C53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 00:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAE86B008C; Wed, 29 Jul 2026 20:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BDC6B0092; Wed, 29 Jul 2026 20:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90CC6B0093; Wed, 29 Jul 2026 20:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93D756B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:31:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A8C5A1D6F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:42 +0000 (UTC)
X-FDA: 85043564844.27.6B06D21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5C2580005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DMLoX7c+;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785371500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5hzEifNAICIGNN+PUDsMpr3lok91oEEG60TAB3VXM8=;
	b=zLT0DAP6DjjmIyqfFQQPx5n7QwL1o08cj9iDB+PRiuamYjAej9VfnrDjVLJEkuFj2GRrz6
	XbFi4GRt0DidH1mVuXrf8W5VpZTH9zkag5QM3dtJ6Py/DC8EYovrdwLwakGe1jSWfZmZA4
	s29ld4WqsmoDwOFo8oyn4pJEXYK8iB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785371500;
	b=jHjDHwCVVgG1wZ7wieobD6paFu4wGIGzE1dAG54ZXjtLr54CdCxigpK5kJ+Idg81WysRfq
	OOheDNYPf3RUlmLfotCrpe94Xmr7Tep/k6S68T5qGcF6Tw4u17IZTWiOXWWCF/xR++Xdt0
	qep14VCMVqShaK8DlaztekZBF0gPl7U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DMLoX7c+;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A9AB600AE;
	Thu, 30 Jul 2026 00:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9371F00A3A;
	Thu, 30 Jul 2026 00:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785371498;
	bh=W5hzEifNAICIGNN+PUDsMpr3lok91oEEG60TAB3VXM8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DMLoX7c+usdsyboVTHPWoLS8PUAu3rFTAKhUd0P1FAnsMdKXSbPc1Q+pL1eKZYNQ0
	 Yb4/cWXSDKG8WmFAlydSqS5t0uK+K78IHewKiPOG17mpOUxUbbaUxeIGhIj1jEDzt+
	 vFBgbHE27zF7jF4GKvQcCcTDiZR7+8uy7JSEQXwo=
Date: Wed, 29 Jul 2026 17:31:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Warren Xiong <warren.xiong@ugreen.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm: prevent page_owner_sort from truncating input
Message-Id: <20260729173138.fbc115b5285e1b465b055de7@linux-foundation.org>
In-Reply-To: <20260729053812.882137-1-warren.xiong@ugreen.com>
References: <20260729053812.882137-1-warren.xiong@ugreen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5C2580005
X-Stat-Signature: epe9rhuemnabb3c9xtasoqzgi1ygf147
X-Rspam-User: 
X-HE-Tag: 1785371499-648324
X-HE-Meta: U2FsdGVkX1+M493tlMkP+I2hbxMDvNbiu+89jr8tmYNGomLjpf6sxBEaPlFLFPHFh8oMg3i/NB1g68DeegE+vcTnrcUZnOTKwS7PAFS+hKWlTmQTPG4+ynsmSnxX5Lb+qutAw6w7i08z/tpBdbN51+yn6vyOF4nSM1KWwvDhy+VjgW4srPM4CAvO+dvHbGhm7fgK9MQ/WbS+CnDM74R92HaRMWukctZtj8yMRgm9JE10ApI1rlqTO5BEsFm1PzaY3/AZZeX9NnW6pRMG6Ul6lhT0AIiPRJd8BzQ8ETQ94p4hBdifu93mc/lRlIHzt55OIUbUPCPw7u1O2Hlbdr//m+28DxOE58IRia1algpW4avSTM9MVtY2+ZKnHAiA3LCo0KYamvvngEWZ5KvNOlEafTsbu8YpKyn8SmjesJf5zRw74yvF6hsXmUWxpJVv+wYYLA8u7P4FvqjkZyoj0UVdwafAOTmcLIgYMS6pEKWsFYf7244+iEqt2VJiCVgowysA+L/GNvXFawq8gF1CUOxzDsIPL7yv3PRFVMWcgtmmSst3djBjvnTrFKB+yAT70BW7NiMusFWgxiEdwmFHMzE6MmtKFmQKjtMa0xEzfXXUDv0dSWTSOvT+jj90itWaPi+e8jsth0feUeU+kMsH0bsB/Kn7/0it1OEq4m0lOr8SjJ27wy0fvzfXePD71+jG3BSwtFyFB9ZcsjtHjNRxxBnw/ux0B1Ln5hVcA+Uek5kN1CUNJ8cRaYLA3+DCKL8Z6LKJfSrtknyqgnQFzttKqdNmpiHk0akfaXwyb5PR+BQkvFz8isvWO8DwTER/GnrOsuuF88uRGV5mThkvOALklDOYFGei+pCOdju1TZak7JRLYBHSw0mN+yiBrBRWlZMJFv7weAlTBpW84mRbnn3UOWIr/QCOI6vUH757QjBWESpU68dxLeMVexSSco+6S8hkXbc0ryYfgB3H9xM0R6sQRVG
 /UZbVmr+
 lMb1odSOnhMsoqfkpmXO5hYkQXZDePhSFntrCOr/5vFObfzc+DruB/TnTs0K8mfPd7KNGNaaLYp/6kPYQ+2eIO7UIG44Qbna+eWw0zkLfrxpGkZPMDCKlpXR2oPexlErBhsmC1WCNwbRw8/0vlIy8vR4TXBHZXBfn55DdmBEt4k+aZLZ+PrOe1Av7dhfjInwjNojv+djm4pKZeriufpkk28gRfmhk/SmPH4SIw7Kvhn7QE8hoRmYb61dnWpCjtEIse2ByVrBc9aa0b9rQe+GgEY7EsOcZK5u3FMAbZJ9CV5Gc3DS1FhR22qvaF/3/7d0eTsw3XbWcum5drZJv9jjrCUlg6YaGIE9mcIe+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 13:38:12 +0800 Warren Xiong <warren.xiong@ugreen.com> wrote:

> page_owner_sort opens the output file with "w" before reading the input.
> If both paths refer to the same file, this truncates the input and the
> tool silently processes zero records before returning success.

Don't do that then?  I mean, is there any expectation that this works?

hp2:/usr/src/25> ls -l x
-rw-rw-r-- 1 akpm akpm 55318 Jul 29 17:27 x
hp2:/usr/src/25> sort -o x x
hp2:/usr/src/25> ls -l x    
-rw-rw-r-- 1 akpm akpm 55318 Jul 29 17:27 x

Oh.  sort(1) does that.  I never knew.

> Open the output without truncating it and compare the device and inode
> numbers of the opened files. Reject matching regular files, then truncate
> regular output files only after the check. This also detects hard link and
> symbolic link aliases while preserving non-regular outputs such as
> /dev/stdout.

This all sounds complex.  How does sort(1) do it?  Write to a temporary
file then a rename?

For page_owner_sort I expect we could load all the input into memory
before opening the output file?


