Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB275C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 20:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770DA6B0093; Mon,  7 Sep 2026 16:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7422A6B0095; Mon,  7 Sep 2026 16:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6316B6B0096; Mon,  7 Sep 2026 16:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 311816B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:06:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 940A3402E9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:06:33 +0000 (UTC)
X-FDA: 85188048666.09.B623043
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CBF5410000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:06:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itj8IO6W;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788811591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iZFtkM4l1pBZzM0aft9DJRPxcvPbB47sa2kHkN4CLw=;
	b=xnE850bl2cncsX8qvE9VFZoN9H+AzFVkjRf6LyqLJs8TiwUeMdmdtVksbrZHrYZysxOfCZ
	CQm+OBfVs61TsJAm2/Whk2jYL2owyGTRK/eZU+cZkQgUsFqigenDuPC1LvVeec1KHrP2Co
	k8RS0MrLkgR5sjw8LDQFsQWdoEccxSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788811591;
	b=h+TfftQPHvN11GD2XQQOFVmgTNOIomDznEtS4dyoZmgJZPJrrnn+oWDPCg6tkC9qSeB0nL
	kTTYq5zqBFfLkAcKouv+McuQO7KISAUUGaYhkfs3KCrGvKy30Sp+C1hytmP5ma46Wo/9NG
	4HiDUWeUNM2MqdhlIgt97ODHqZRHN3w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itj8IO6W;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC6E043CC4;
	Mon,  7 Sep 2026 20:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E356D1F00A3A;
	Mon,  7 Sep 2026 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811590;
	bh=8iZFtkM4l1pBZzM0aft9DJRPxcvPbB47sa2kHkN4CLw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=itj8IO6WuGDUlG4fV19yF3V4rKpQ14rYl9UeIVKDmHnSJolv7EFD8UQxFlCdkBVGK
	 ws9Vqsg1Z5r3sQcqqF/wAeIxdjJpCuEOH8c/snnX01Cix6RsOz8HMTuSuIxyouMrEX
	 N9Ho7R/MyeVcbXscY7gENbyUtymnAzjTKk4/z1IDjAsYrtk1M77rWloHCt2hqKJLKo
	 RJGm+RXuXyXLJDPqMwjCCESNFKNgKuiECjrFBmLVzhKAvOx6SXB7UFw/iN06DxwGtd
	 PXj/TdTFDuHpUbKZBcLTJzspv/NQjcVuLM3gTFfWwF/b6764/khZWF7e+zmsWaTxUO
	 tAY1Bek0OCNgg==
Message-ID: <daeab5a8-44b8-4933-80c5-e4145b01a0a1@kernel.org>
Date: Mon, 7 Sep 2026 22:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v5 1/7] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>, bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, andrii@kernel.org,
 ast@kernel.org, brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com,
 song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
 viro@zeniv.linux.org.uk
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
 <20260907165220.52431-2-tasos.papagiannnis@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907165220.52431-2-tasos.papagiannnis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CBF5410000F
X-Stat-Signature: u8omorqfacrcp5xnxonxesfhy4fp5up8
X-HE-Tag: 1788811591-231687
X-HE-Meta: U2FsdGVkX1+gaOanDdZzlE9qsfr8VTN23xdJj5C2BKRKItgpsnIZsUMb8EMKTYMxPoM77u2C/mtsHIu64avJ1LacK+dfNsWbZagdpWT4zosAw4zV6aS9jetTqJd+VQQPurgFcJqq5aR3lMg7a+Eh169MhjAzuxHYs+0Pus8oONgsmk9mq8QYLZzCzb7Kna+bbjMZpEoSYkgqZaIVICPw/S2n/qUgkG2EHvodt24eyLeMhkzhPnDjtg2AE+pQahkvXMqK8LzIavgy1FUGFJ2Dz8tzThp0KIhbgrM9wbzQy4bUAQWOPsZJtg6H7ErtcvTWw9kiRpKCKQHP61cI7UGt+6TAwT0p7L5nnn+wRXcn2bL1jWM3uuAWbm+q65n6gFW/EAzhOhacMGTfTtNrX1DzMLRgFDI/UWIaaQWs0fs3Z1cQ8Tdq7ky71K9G4LJ2GRwDT8KkvcGfm+5cWIp35cdpRpppWY+jNxoMpi4DLM/8FbB8vx69DUUHo7B7DKDgcw6V84YttJzoxR+S87O/kfwZ99f3pNPAk88x4GMGMmZc+QNeXlgPSosLQTfzymTZiTnTAYcp++JZuYQX2BVsS1ztTuQqNr9h8TYB8s1+mtlbG0X2HAagqZslsp5hH4ydT/4QaMXAOILmQN3GdEZMG5YzttfvopD1qv88XvUp5Odl4YDFqg5sMgStHsX7uU6zuodsJI9Hz+uf17jnm15oeZMU+ASLAV5GnDpCvzBW4TqxG6L2L0sS9BiFeQCxzxBGBmgm4VfVvLE5YrexGO0QdU8QpZ766N3f75DZR3A+22oDRrqmrRFlGonon2C9x0jOSKbc3NSlJiAcleeOwg2pdapGsh4TL+I+VsSFa5/LyPNhodSW+cwL9VrQWHcgskTiDyGV84Yok5CuQDT6eIK78SUIJsgjy3btDJdqVSO1BlhMQr9AefjMB3KGxeIeXiUTiRRAKXGZJKjMaP3wC56MiSt
 Fm/0D9kn
 Q2HLi4Z3L1HHR6hRKCQLsnGdbJmIinEOwV1AX8osRBzF0haCm6A5R0C5vSM5fZiDSfWr3xKL0SIw/R+4tZPpHuARq024PBrcqsMsX2NcSgxSY0VVyZbcbYrGtfPiOdfhLHBeBLWj2TzGiEUpyNtzqmj5BjpvtQEsBUoPdL9ZKHiImc328i4dXhNmvuUSMOZKhP6TsmHOYaQddTHzVzwedqmDaPFKcXmsC9Y1jFOK60boxHPds1WtZaTS6Ji878ofs6Fb9Xo1lSsBwoZKRV3xlX7E0UD/CS8DWqy80LEyo7ZVUgKiZmJwRbCdsbQk4CCs3t+DqUAg4P2C/ILG5KI0F5QjhzHUbUh13btt0HTV6m3RAwszDevPdG8N/AIrMb+tfhB0mTSwiE5hOV9m0BMcZZ7Elag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 18:52, Anastasios Papagiannis wrote:
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
> 
> Add copy_remote_mm_str(), which operates directly on a struct mm_struct.
> 
> Use a common internal interface for the MMU and NOMMU implementations
> and define both public wrappers in mm/util.c. Preserve the existing
> copy_remote_vm_str() behavior, including handling zero-length requests
> before acquiring the task's mm.
> 
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/internal.h      |  5 ++++
>  mm/memory.c        | 41 ++----------------------------
>  mm/nommu.c         | 41 ++----------------------------
>  mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 78 deletions(-)

Almost looks like a cleanup now ;)

> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..d5bde1f71a97 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3326,6 +3326,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>  
>  #ifdef CONFIG_BPF_SYSCALL
> +extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			      void *buf, int len, unsigned int gup_flags);
>  extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  			      void *buf, int len, unsigned int gup_flags);

Ah, no new "extern" and best to drop the "extern" from the other involved
function while at it.

Also, you can just drop the ifdef; the linker will complain either way later.

>  #endif
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..8264a346d18a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -25,6 +25,11 @@
>  struct folio_batch;
>  struct hstate;
>  
> +#ifdef CONFIG_BPF_SYSCALL
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags);
> +#endif
> +

Same here, the linker will complain, so no need for the ifdef.



Apart from that LGTM, thanks!

-- 
Cheers,

David

