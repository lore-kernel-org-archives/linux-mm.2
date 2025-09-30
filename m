Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8186ECCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B748E000E; Tue, 30 Sep 2025 12:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24948E0002; Tue, 30 Sep 2025 12:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B136B8E000E; Tue, 30 Sep 2025 12:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 951718E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:44:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1647887D04
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:44:45 +0000 (UTC)
X-FDA: 83946490530.04.EA47B6F
Received: from outbound.mr.icloud.com (p-west2-cluster2-host9-snip4-10.eps.apple.com [57.103.68.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1B534000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:44:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=danm.net header.s=sig1 header.b=M0QfT11h;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of dan@danm.net designates 57.103.68.173 as permitted sender) smtp.mailfrom=dan@danm.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759250683; a=rsa-sha256;
	cv=none;
	b=txayiYJ9EM0/nRcsUAU75rtKIWZ/RfA+unHSD+7VNUZGU/0PzPIXJiUpidAt/4Esb9imJl
	W/azHwnvv1L5Al9UtVmIydeBb17058yubUEWxjzsi/spBnIxkg7fyt97g6MzL9hyx857Wm
	qlsYaVpGZ4gEoxAMwkTiwrcvKTjzEzw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=danm.net header.s=sig1 header.b=M0QfT11h;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of dan@danm.net designates 57.103.68.173 as permitted sender) smtp.mailfrom=dan@danm.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759250683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wm9ID2j2FmK+Vgk8dah0ebA5iBileEnik5nUL2fWP+E=;
	b=N5G9ExwjDBVpp9MWJ94Aw6Lsq10GgROU4cQOz+3Jap/5zzXaA6rHEj1A7eX51C2fB6oabf
	kE3N11ha/N+Hrr5Znw8MYrz5I3NjEddYOAMROSOXyMtwYXxFnb1d2RII/tgv1ADcCzm/mC
	cjjiLyUIijS7MB9M+fok4DcR6agxcQ0=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-8 (Postfix) with ESMTPS id 33C371800475;
	Tue, 30 Sep 2025 16:44:40 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=Wm9ID2j2FmK+Vgk8dah0ebA5iBileEnik5nUL2fWP+E=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=M0QfT11hfp4fT0baMyGzDZARMgEcSsCrzc28M8oY1rSNjAjv/jYbuw+JUOHjBAzSkNQTwJLhZJlyzkg92IdsbqHvAYHZE5oSPgOZ1dzRsUIxYnBCjQ1qJhpZrKThBfZ3csrvCi3ZexrLPwXMYEUObien1VJ2cEtu8ioiba2NYGRJ3ctQ7wQv5DhUnrczdbdt16tjaJj+h/oa4vj2sKUejyAakvIk5P/HGjRIKnOYDqgJDQqEDVg7Dh02DF1fZhgOBASkI8MyIGa+qT5Z2bu/RbelwLSzJCa25AF/mX0QRHqj+LHdryZjcv+++3pQ7jFGrLHTZaWhiA/DpFd+jwIwDQ==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-8 (Postfix) with ESMTPSA id 210331800727;
	Tue, 30 Sep 2025 16:44:39 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: rppt@kernel.org
Cc: bp@alien8.de,
	dan@danm.net,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mingo@redhat.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	x86@kernel.org
Subject: [PATCH] x86/Kconfig: enable ROX cache in execmem when STRICT_KERNEL_RWX is set
Date: Tue, 30 Sep 2025 10:44:35 -0600
Message-ID: <20250930164435.23044-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250716075410.82578-1-rppt@kernel.org>
References: <20250716075410.82578-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: cG4KWAmATXQyx7FFLuCD81Uo__oEgFa9
X-Proofpoint-ORIG-GUID: cG4KWAmATXQyx7FFLuCD81Uo__oEgFa9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE1MSBTYWx0ZWRfXz8P3zTxNrIHF
 1KWtKv/lU7Koa3XlAkIY6Aj5DINjS5W+k3NVkhej7CO4nq0dbIUs7q5v84ZWoMoBQNmEX1179Qp
 9Dw/6fwfi0Ne4xu4Do2OLV8cOM/blTNT2A4RAh0QJJwech7afQqxs+Dx4yqfYO3QnYk2U4ryTH/
 W0s/VTyI5V53vJma1Q/IWYBwVXoFz3AIPIo7kaJWZpngE+oc/7W98GtftlJSjmixbrE8IPMQciy
 +RPHeYe+w3YxwQRypYavcbUnuOHqxx1K575eIjfmm9PqC9SDeCDB7VWdYaL9xCQy9AvjyGUrg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=809 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 adultscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509300151
X-JNJ: AAAAAAABcuBZ8q0QzjvlELe9DWsTh2GsOakWRdAqUjNuhDJWT5r3sHSoGaqoyzKhJF3n0/v10tToMycMq9zku5patHVTMyghakdn4mX0yWg2S8GRgCB3+Rb+8n4DqGhiWJ+PbF/1ak4hg1FH0dS8nvR+dZqJ1XHLalCtNv0XkGWxfZIq9KMZYJofOmQzf+3P/W8aBmVMTV9BffApInu5/0V81M1meMXZyTc8Uj8uTSeoNvAuUQkeFdip7u4AAVqCxh6JUY6rB+LyBed3DN6dAQTRn7bRX330fvSnIKct5NKk+xeyVE5eJe4ztaEYRqfsoNCDZmtOU/z6Cvey3p8pcd/FN09n1klVEky/zmbaMqlcxV51eHaO2MLRdglMLa+QJsB0JUqQMBZpW6eqa99Xf3NDWXxlZzXLRcAPp20aMjNukzLlDrBMkj1QUNAkWuZSlTB62uq3VfqG9IYN0LyT6UKxUSedP+23uUfVTQVmZbtKhRE4wvLk9//gxN9P3Z4fnC6Szl6RWWelAUZh/7uU7FBLvsilXgz330pFBL0v+UXHYPXaXWyZTLyOxWvhf4lvMsO/CC9divcL4bCco4VxL3Rjit2x0o+LsZagVixxmVSBHGtxjOcKAzPWxgo11oO0PEFRxEROTwIQ8A7O2IpiJ6yomONJa/1leUzbV6z4BJY9n1CDvs8zNkN7xDQO1DWrch1c76ud
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1B534000B
X-Stat-Signature: rorycm6usjkj88mp6qh67jwbpqqwboii
X-Rspam-User: 
X-HE-Tag: 1759250682-635861
X-HE-Meta: U2FsdGVkX18UZKo7PYAWtkyXMDDgCnGQLeaX4eHbODyIAFV9YVwoqxGcAUN2AkFjCDHNf9hk5rPXl9XHi8oEo/YCtmP2gHmReZUPYOgp1gVEktmM9WCBhrDwi3kf2YVHoxj0cJojvOGEuppq//d0aAy/8n01MTfigxPtxw4IXcHrgClqU4thRZVc2ZLPhFnlcrmqhkqSMIwtbm0IqikuuPoRw3LHKkltRfFKMjztNWB4BVlQujTNRF1YEk+yazuLoQtuNa56HQG1TVmyrLnjQgblZ7QWUduWuirxqYM7KZpO9O0dJ/fPUbwEKQer93+dFVWjptlFdRkPSDaSUQ+UTd9/HEEK1uGzvN/wR3cvq3trCzFt8+LwyCifrbYWWYvu5R9p9SDc3AuopGOK7frxJ5xIPvcHEypE6wXFWGXCOcXtVFtOrd0o/GYY+HKuSnqYgAGEPAHg6aioSa4kOHiXxgU/gSaQY38aCuYl96ZcBUYJ1fdD9X40wxWoAvBGoFu05/vt9RoUpwSdr1Ysgu+m9S0TH+a9Pk6LeyCKxWEHRqIy/JEMbHo6M3W+9fEIN+0RQvhFHaIMW/AHA+1Vdzy1XN76krvT4mFHaSxYEpFI43PvoGHtY7KTgA4U4uQmSxMFbFSW0TZrNAVwtuh/2HS2vqKq6L7T9nG2Aef+rE4A9Xd4r+tvFZQzbXyUKrKu6gk8VdP8Ios97DqY/OYBNZW4JTvR7JIFfGEcQ0ZU0OUVRPebNQTkRbrPxLvUtwYZXEsFb11+o/1qR0zJ4POPAzz0S95Nfcgzq/ZT+xxYXOBj8URZQY44AV/VkC9GgG7vC8QrOjjuj6c47tKSx9pyoDrIVbSAOYR358PqOJgXR50Se4t9FUV068I9cIxauk1FH0PlnpFYrx0xBguWMOTLFYRV+TxopV/sxEuI/CRGniek4lzYzz+uKdFnnr39yBwVaynGsXGsd5QI0S1UPEj2Ub0
 wfFwxkIz
 D1PzzQDeNqqoJTYQt+zir31bXEwzPKzunqfTQypfL4TkXSLBULfOjR2d7M/0lzT/ie9Xd2eEfTmzcRtLrAKW/k/k0r3TO1dItVGB8Ok39hwdKlw30ShH8rfDiC5Nmmu9zeShVJW3A7urbdHlJWXZRm0v13WVlM+SOTSDxxA+kJpl0o0cUC/6knrTLptYS5BR+kuTHz+5mtPN+JtPD1nAemGYJYnncLKxnP5/BeEkgFx6RKR6CzP2bCvIn9wjobxlE+0pkbhzPgmMksZ6n6zKT9ZzxyATRM7/Muimuyu1pCpv+54o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Dan Moulding reported that kernel configured without modules produces
> "Found insecure W+X mapping at address 0xffffffffc0247000" warining:
>
> [    6.022847] ------------[ cut here ]------------
> [    6.023020] x86/mm: Found insecure W+X mapping at address 0xffffffffc0247000
> [    6.023200] WARNING: CPU: 5 PID: 1 at arch/x86/mm/dump_pagetables.c:246 note_page+0x6ec/0x790
> [    6.023381] CPU: 5 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.16.0-rc6 #1 PREEMPT
> [    6.023558] Tainted: [T]=RANDSTRUCT
> ...
> [    6.031153] x86/mm: Checked W+X mappings: FAILED, 10 W+X pages found.
>
> The 10 W+X pages are the pages allocated for ITS thunks. With
> CONFIG_MODULES disabled, CONFIG_STRICT_MODULE_RWX does not exist and ROX
> cache in execmem is not enabled so execmem_restore_rox() becomes an empty
> stub.
>
> Enabling ROX cache when CONFIG_STRICT_KERNEL_RWX is set solves the issue and
> makes ITS thunks memory properly protected.
>
> It also ensures that memory containing ITS thunks is mapped with 2M pages
> for kernels compiled without modules.
>
> Reported-by: Dan Moulding <dan@danm.net>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8bed9030ad47..d6d8050683ae 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -89,7 +89,7 @@ config X86
>  	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
>  	select ARCH_HAS_EARLY_DEBUG		if KGDB
>  	select ARCH_HAS_ELF_RANDOMIZE
> -	select ARCH_HAS_EXECMEM_ROX		if X86_64 && STRICT_MODULE_RWX
> +	select ARCH_HAS_EXECMEM_ROX		if X86_64 && (STRICT_KERNEL_RWX || STRICT_MODULE_RWX)
>  	select ARCH_HAS_FAST_MULTIPLIER
>  	select ARCH_HAS_FORTIFY_SOURCE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>
> base-commit: 347e9f5043c89695b01e66b3ed111755afcf1911
> --
> 2.47.2

Just a friendly ping to see if this patch has been applied. I haven't
been able to find it in any of the relevant trees, and wanted to be
sure it doesn't slip through the cracks.

Thanks!

-- Dan

