Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED20107BCF5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17156B0166; Wed, 18 Mar 2026 06:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC85C6B0168; Wed, 18 Mar 2026 06:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD7C6B0169; Wed, 18 Mar 2026 06:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8E036B0166
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:43:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2016C2305
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:43:02 +0000 (UTC)
X-FDA: 84558846204.06.C4D6936
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC3284000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:43:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MmL9XxuC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773830580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fCCWCHwWggTi9UgwI2PN97b8xCYTIvEQ9Umm7Z5SywM=;
	b=Bzd0WpACLqz5TKletpk4GRW5b3cRvlOuYGBS+AsKooRbf/RZAYqVj+0ukX6TqtZItQdf82
	P5rjrt9nIP9kOa3BtdrK65De/vIOy2ywYi3yRP2Z5v3KAdUIKyBZoCyL3qolSi6ft+0KLW
	HiPDm5bnvWyuM4tNhVgUT9p9+fH1d/Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773830580; a=rsa-sha256;
	cv=pass;
	b=swstDa3J7uKNFcLKDRjqVCfJhftRSGABg1NMqkORu8bbVotRGNij2GYLvmDovuACX/Otb3
	ZcEySj3zZ7/Ssvc0Xo62JU22V5zxSKiH9SlXxoqq5AzqYO9eMuqjmam/T6LcEbrMJKh7Tk
	BRz3lhYfdhE+Fujz+CGI808ch06XCxE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MmL9XxuC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-67bb0267a2bso2398403eaf.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:43:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773830580; cv=none;
        d=google.com; s=arc-20240605;
        b=iwEjZ36zNLK6VVNjDZJ/NherHIkQB5Qs4JvmteDwZ9IlcmnzNEweQFsG7rYc3r6dbE
         ZYXVQ0leq6rDGrkDjylwXwqWqvmd9lq7DYpMtep8pQxxy51rrue98u7dwPhJESfp6F0W
         bXgP8/FiC5jkvYG6+sfYLodjyGbo4/NpOjr9XUu+hQjVGHc7htMXUFDffqvEkD1eUy4r
         UYSL6P694X7feepF2tXvAxoAeLx7XlbE3IBQMDnRk83S2lLMvpOoc3ZU9xpiMxREpHWI
         ReLYmZg5ERpMF+mY6H0sXbwWLmmKh6q5/4q82ZsZsNN6l4isFtBlYvEDMVVBKZMNZP0i
         /AVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fCCWCHwWggTi9UgwI2PN97b8xCYTIvEQ9Umm7Z5SywM=;
        fh=+1r5YKd7BRJCKYTPWRvejPrUZYDxaxu2DZ3k1hOPyhc=;
        b=Eyf/+yKnr77QKQW6r9xk8mYGhl2Ci1oS8FelsI02qVObwXj4jjqmAkuGBYNT3jKvNI
         GtY4Xg2lsE7GCcXV5pRZXFgU+gkAEqTSeCY/dmQDj3DV6FIDwZdK6Jb1DyS6Nztz0oK2
         oTG7OtDt4nlgYIqt5h/Y/jwPWfvp+KB4Lf62iMCM3mBResFfGeG/yxDccrHkwcuX28TU
         62/nGS1AbBkhrg1qOVD+fXwYn9aic6Fc8Jsr4nohGcSgYZwbZCNJZL6LBjKK5YD/BD9J
         8kyAtriHy5nRV4cAAJ2sODwHO6N4B96XtUAO/zUofrP607ivwIbp3QAAQjp3KNOJlcnd
         iJeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773830580; x=1774435380; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fCCWCHwWggTi9UgwI2PN97b8xCYTIvEQ9Umm7Z5SywM=;
        b=MmL9XxuCRUYAsH/4pZ9QQINqGL8JcdeJieEMuegkVl7HhUEXq//twGYfhr2FoDbVBb
         JOrz8JPF/hYh+HCoR0miCOOcAHpY/ifkCXU7qTFpZVAHpZ9ZnKUM0zKhX/A01s90p/qr
         mEnIJSU7qrq9UKSd8pnwzLdvE4S5zm2SjjJULMATxWpFhy5ZqAgyvU4k8IQopHuVCyn6
         tsftKHRRCwF7Q0njYeil1GRrryNhNx6nHv6sZ2srBjtX3Qx7n91ScMPdd871K3wd5eLd
         deYBSFdM3tUIi3RQ3EDv3LjDe+M8T8c3fqRM4xIhjaWiP1FM8AhEnHNPihUeORdxf9gQ
         V5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773830580; x=1774435380;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fCCWCHwWggTi9UgwI2PN97b8xCYTIvEQ9Umm7Z5SywM=;
        b=H+rNTltdiz2zoyrPgOYT0fnuB9H+QnPXuZeZZuiz9jqorDkDxe5uXLMltXVqoT0S2u
         4dcgIISFogex8RExBM1OKyM8uvo6h6AeTlCgObizaqIWjMdInVx/431Jehbl0Bm//VWA
         Wu4upub5ziL143hgNkJK/Uu1VReB6f3YUhEQTUeX8wVMzHUywNuggcg8y8kRkXiOyuan
         yNJ+cXBcGk7wDsqWTrYn6prwBxO8spcsV8xQeLvwtXWaMtnpW5Ri6SQM89rc4akSkTQ3
         Uccw+iQvoarhD2GVuHz5/zCQSWzkD2pAlfv/8qH4/Z+EUp3JChyM0eUAmsaRkqOTmBOk
         3IWw==
X-Forwarded-Encrypted: i=1; AJvYcCXRFckXzTHlPb2VIpJhGb9JbCv1u1Vcvs7pa2GI/Vt2Ma8S2zfIQaI01a6BbSs/fPajcsjMEkd59w==@kvack.org
X-Gm-Message-State: AOJu0YzgA/Hari7LQ3+RMlPkS7m9DBes6vGNHwF6Cmfs5WI/dpnBstrF
	wdEy+khmErEdaNyWX/hUbnIeUT0owFLfS35YQMj7B7JKI8afGQ2HKa858Y3pGhBApOIkCpHP5J1
	IKYkCMh6cJ455x4KN+plDNHpweiHNA58=
X-Gm-Gg: ATEYQzzkzu+AaQU02kNUxXX+zv2tsIs/D56rIGTlgmFX1msKR4201D7u3d9N/Ch3/Ta
	ZExoO76sQCDBE4AObv/NptSbQmPER9EBj3tT4OH1JI1S5zSPfopUVTDVFXecZuf+97JJy1aPifK
	G+QpYJElGyT2vttNdayCdW4Fz2/F/Chht9D4ZRWS4/zqtEkFheQ83IloZ34wB3WkrqFFyC1rGYj
	/pWUc/wqNaqEBLk3XH5H0daSUPpBcbOwE+83+YYx0prRGaJumnvHwCyGlmAzTXaLJDROF8fy8MO
	po3PdRi+A9HsGvMbZVobO8krgaa5GnQnrWlWQ28=
X-Received: by 2002:a05:6820:2227:b0:679:e750:6bfa with SMTP id
 006d021491bc7-67c0da95057mr2030129eaf.10.1773830579697; Wed, 18 Mar 2026
 03:42:59 -0700 (PDT)
MIME-Version: 1.0
From: Jiakai Xu <jiakaipeanut@gmail.com>
Date: Wed, 18 Mar 2026 18:42:49 +0800
X-Gm-Features: AaiRm50KzGeGk4U1ssZVimavxVmOrvZRNHAY-bomh3FvQZNpLi6C2Zya0jD92cM
Message-ID: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
Subject: [BUG] WARNING in unlink_anon_vmas()
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, lorenzo.stoakes@oracle.com, 
	riel@surriel.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 6ztbg9adtngo1oj9b8i5cksg7yxpp8sj
X-Rspamd-Queue-Id: BC3284000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773830580-369463
X-HE-Meta: U2FsdGVkX18kCGv9PFrtO4FCo/I3v80tGWpiCQ//aWwU0hLIo0DjhSbvtVoUojS5R4Y2j7vINVvk3eYFKb5Ov6x0u0vsQ0OrUtL+1bTlcpU3k/VN/+vDB0OEiZ1z/i/xUR4w+6QMWyKIWvZVJ9CfGwR9ft0iTOVAD2X6E0QiAyeZKTv2gNRws2tAopzxqosDDX8jV1nV/wBfnsCzEbzRVLvaHasoty1O/qyPwn3wEogXYWPGnLSvx91yg+4ZtGXGWcxMydk2iY2A1xN/JXZV0OZ0HZiBpZn3hlqGDHrj45EQa83eENRU/NTwpSpFZAkIhj9gfXX5t+6udmrKHEB/+QaoiXbRQIpeVqucMXiZruplgPV4wLFnHC7jGn6kxNMPmkt0hj0T1PpuUC3fVsIBtyf9zolQj9gueaaU2bF3GkzfAeh8F/JrpFop8AE+Pmmzvsi/9ABo+R+dzMUB5N5HY+76hLLe4pLwRv7qD2FVoHkPVCnBdK8AiXrky7nBjsj7MQCNadAAss+dGJAze+JYanOAU6LCUGAXQCk5h1TsOjmRSHiReNxteGmTM0iytBzuxl3WacoNU6VwUbguXaHXgz3TC4CUi2yDK88I8LTbKi4JOGBB8IUM2EuPLdg/UGI+5wyLLAwxTdGPAjSQpl/LrgCGLPnw0taeLYO7ZhQq3xWO68a60rP5yRCvdyMvMJuzMSkzWA3QKcCGCl5CP/txDIFCurbsK/gL9qf4vx0m8p09su6M83bKRHXCtPyhSgZrjl4gkpTPsHM6E/qF+v8+k6Up90ALyehqy/hxbIGbG7Rg694TJjF/IMmZ0ueYmXyunw8u7sl70WLtmolVEtlzgTr8OUfASObwhfy28khNP16ufHeNo/0ejQXqtZzOk11zVHB0vfMl+xTkhlK/p03yUTDiAv3VhVAsHmh/8bXCCANifUoQEdUFsDD5zdMi7UTUBMdMFwg4X/m0rxX8pDu
 Dig9a+/Q
 jKbD8c3KxlnYg7HRhZVsf3dD1gLBiceO6VQUkwbME7nKkQfDQfj4JQSNaTJEn4Pe5bmM/lc3XiQ0+E2//niZgPrWkts7kJC7val1CSl94B2NnQ22FXjWF0yo2kL2fY80pYMX4GE0TE7QQS1B3UHoQMPOdBnyDZdXxvb46QuAjtV9km8XWT1FY1aR1iWFC8PEwQlh1aRuVu7Gy+En40rPEPnzISl49jtooo5wBWIGp07dfw393D0liwDb1uZXjOeJwnZRovKGMzW2WA8is+GF6NpZ4cGn8PBpSR+0IOeDm9BOZ7kECs2YRx+kpCPPKcStqrTF429/MGlYmASNE1OtKii7ZRJxM7edS/6sMj+YTBEoCj1D9KmkF0nNDntduGZARdD6ii+um3M5/Nl6Yer1k+2At/1zJbD11OLcCB4OiHpk/afx5oB/FoS/5Yn7B9KoTzBaWtfh/bCFQlV9UETe8qyg77LZo3tKY2q1lLDocNNYjJQulv/gw7BhXcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

While fuzzing the KVM subsystem on RISC-V, I stumbled upon a kernel WARNING
that triggers in unlink_anon_vmas().

 WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
 unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
 free_pgtables+0x2a0/0x860 mm/memory.c:427
 exit_mmap+0x406/0xd14 mm/mmap.c:1314
 __mmput+0x114/0x3d4 kernel/fork.c:1174
 mmput+0x74/0x88 kernel/fork.c:1197
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x7de/0x2adc kernel/exit.c:959
 do_group_exit+0xd4/0x26c kernel/exit.c:1112
 __do_sys_exit_group kernel/exit.c:1123 [inline]
 __se_sys_exit_group kernel/exit.c:1121 [inline]
 __riscv_sys_exit_group+0x4a/0x54 kernel/exit.c:1121
 syscall_handler+0x94/0x118 arch/riscv/include/asm/syscall.h:112
 do_trap_ecall_u+0x39e/0x62e arch/riscv/kernel/traps.c:344
 handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232

I am not an expert in this area and have not done a deep manual analysis.

The full crash log, a reproducer, the kernel .config, and the relevant
source/commit info are available in my GitHub repository:
    https://github.com/j1akai/temp/tree/main/20260318

If this turns out to be a real bug and there is anything I can do to help
with fixing or testing, I am happy to do so. I hope this report is useful
and sorry for any noise if it has already been addressed.

Thanks,
Jiakai

