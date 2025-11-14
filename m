Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC29CE7AED
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888868E0009; Fri, 14 Nov 2025 06:31:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860E38E0002; Fri, 14 Nov 2025 06:31:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776358E0009; Fri, 14 Nov 2025 06:31:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6376D8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:31:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1270412DE64
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:31:23 +0000 (UTC)
X-FDA: 84108996846.03.B04808B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DA2AC0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:31:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awS3On4f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763119881; a=rsa-sha256;
	cv=none;
	b=n4b+Qylw+75uiGw+CcMRRwj9NJGLNH+OCWepn9DBDdN5h1S4ggUgF+yiwUyf3KfPEXAg+K
	sKj4wQzg5JkoXWKEeL2CmDLDeI2rq7NPP1lTZkhlojT4AUSmqBeUBl1e2RhiU31GUj3iwE
	lC4BDVoocaRHlwc71ut886PQ90/zOBQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=awS3On4f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763119881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afNdsW9MU7zJqHMqx1ZLWRpBncJwmm/vMMXpi4TcjY0=;
	b=1Mpx2zVN/VZ89YzPljsZ5s1zxJe6/tHjVGIkfm60YrJzQnHlvmtkeIdOnW26WxDVVZoDUa
	akMS7qQg/09tFporCR+IWCugjyTYUxig+GOXlAEy8METPHxA1nxRPeIjg7KCOgMiuztSui
	gMjmG5/cE7Wi7BNiRWF15Ga5yHBLrwc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51BF3429E2;
	Fri, 14 Nov 2025 11:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E5FC4AF09;
	Fri, 14 Nov 2025 11:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763119880;
	bh=GaRt8mZMwQZGrcQ9Qajr5lrJ1sWQayWo13cA4bzwsac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awS3On4flAlVPXnqWsYldgKjJTlVNUrXTI2f2IlBW0Mq9huNwec+HzA0o2vnASTRC
	 s2wSviLIQxbhJS1cgM3qY8D+PSZoNgxQLJMbhP+D59wrYAIcUTPU1nUTw4uc+kF49i
	 JZl4ja3iTV9+fg9wbvIbbTxkq6hsIQgI5Ek89x+esVIdOSLBBLRZ7QnfRZ0otnljJz
	 3Wh4BzCs3j8rdc77ctn6nYA6gqtu42YDZ1g0kDPONFM3yPke2HC09711bzh/M3eSqC
	 3IN+FfC2sw+CV8iY/M1yskLGfYGhXR7k9C8E7qVXe1HT8PbeiIKUpTprYobKNaWtKt
	 weG4if40H1QMQ==
Date: Fri, 14 Nov 2025 13:30:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 03/22] reboot: call liveupdate_reboot() before kexec
Message-ID: <aRcS7YU0CGc4NdKX@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-4-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DA2AC0006
X-Stat-Signature: we9xanrkwpgddmfrxe7p5g4j7i6hrqi1
X-Rspam-User: 
X-HE-Tag: 1763119881-870090
X-HE-Meta: U2FsdGVkX1+dH7bcjNaJlaQ5/mYojKZhjTCHvx5eUSJuVcRUHQKSLloYYpdidqaY+m+TguPy8D9j+mIgNJgqIVhahd2NCapOW3bJpecyUj799lmy1akmqhG8qtnmWQS7jaxfuplb4uz68mDuSON6cAs74MnxXwn11ZxZh+95sskr1pu5tuvxOXpXUv+OFNaEdj84PaBz5Wppsa8iNTOSsFiOYOM1J3o8doxFJIGiRjN3qY6NXr/ELx189QBRiPx8UmC/wI4GGNTJmKrlCEUJBlbIvT+y+m7lPyM6RtTkLUdk5cdd6eT/KZA514Z5/eFnn71Xxzk+Jz2zIBM4pS3NLQ0Onr8zT9lAbhhkscaWtBzKyxCRUy52q9VOriwe6QEPEMMHmM6a3ExP0/hJMEe3zSIagopVt3utjUDH8r6PqF/6ECqBQdU+b3VGiIkxTF/38Ena91Q7IBgr8NFymU5KdaNU6RHN6XdWjB7rrn5yAk2X4EZNGsM8gXe7IEELMvmGcl01XRrsPKnlg53cx9VBWs8XvcJrKgOPdy+UhATKjqTluZKbZGiz3p0umeBYupyB4W1UJVLgzkdloV/LxudpERU9eZfzSglQfpxr/suWfiWRacdgzXAgi4r0LiBpoCoEFq6FaulPKblmOPySduOgg5tLDVeSC+jjb2dJfM0DeJn8hgjClcRqte/kc4LZicZVcLc4+V5u9h/mNTsHvGz7y+1U+7aEJTm0Fk8clT/759bXcLUwWUfX2UtQUHwGDBF7T/glYjJh/Zh6it/sJcz6CibEee9Ns9ZysV3geMs/ypyNq5CvCbQ/z5N3PBhh5alIkw/txU/sDT9B3Cakwy5gGgbhotwnoaSLOhLI960Sz8oMuzxHfvWWrsiFTGC4S5PgaD3ueL9K5n+lQ7qY/YW11HVAuDQObf76Uh1jwcqwMKdxfbtCSptmLDqqSamWE5PV2uRzz0UJR+aQHnlTy/T
 Pjp0spYd
 yuc7Htd4MMMVQxzYMnlpgLi1PEnC6srlee9x0+0y4KsnOW9yX4MKkQ3tCDi+BeL+vlhMlcycAAiJgf0Ck4gsflQieIqKffUl6DHLxCMyjjhYXUjUwWttAlRETQuuIS7k33zHPjInWxUEVMS9xUd4abPtuGJvOt1XKpLhvkNdaGgxjRPMmzQyIo125M7ySHZtdepfWsMf5GyJ4IThhrveARLB2oRNXhwNctF0q0gcaQO8KHQwBD3t6EVrlOmkTr//fmtVINZ1NlvN8Hkixqa/dcQd90M2XRn6mJtdgD+YPXI8ckZ++vYB6AnhJ1VyWF6Vw+W1KzetmRTcWcuIXS5vf06fXIg4Ai306A4A5fCyG0MwTDgFip+2wLUNcx/r3F7l4tnVMvI1qx1He1SH4j7kr6ryCFzJIOUT3mzZZSQAZpuAXwS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:01PM -0500, Pasha Tatashin wrote:
> Modify the reboot() syscall handler in kernel/reboot.c to call
> liveupdate_reboot() when processing the LINUX_REBOOT_CMD_KEXEC
> command.
> 
> This ensures that the Live Update Orchestrator is notified just
> before the kernel executes the kexec jump. The liveupdate_reboot()
> function triggers the final freeze event, allowing participating
> FDs perform last-minute check or state saving within the blackout
> window.
> 
> The call is placed immediately before kernel_kexec() to ensure LUO
> finalization happens at the latest possible moment before the kernel
> transition.
> 
> If liveupdate_reboot() returns an error (indicating a failure during
> LUO finalization), the kexec operation is aborted to prevent proceeding
> with an inconsistent state.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/reboot.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/reboot.c b/kernel/reboot.c
> index ec087827c85c..bdeb04a773db 100644
> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -13,6 +13,7 @@
>  #include <linux/kexec.h>
>  #include <linux/kmod.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/liveupdate.h>
>  #include <linux/reboot.h>
>  #include <linux/suspend.h>
>  #include <linux/syscalls.h>
> @@ -797,6 +798,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  
>  #ifdef CONFIG_KEXEC_CORE
>  	case LINUX_REBOOT_CMD_KEXEC:
> +		ret = liveupdate_reboot();
> +		if (ret)
> +			break;

As we discussed elsewhere, let's move the call to liveupdate_reboot() to
kernel_kexec().

>  		ret = kernel_kexec();
>  		break;
>  #endif
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

-- 
Sincerely yours,
Mike.

