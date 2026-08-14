Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66086C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606E16B0651; Fri, 14 Aug 2026 04:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDAE6B0654; Fri, 14 Aug 2026 04:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B1A6B0656; Fri, 14 Aug 2026 04:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC026B0651
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:22:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA3111203B5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:22:21 +0000 (UTC)
X-FDA: 85099182882.10.6D6649E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2B9F1C0007
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:22:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGdB8HlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786695739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIsk+Wf4F0dnluT9f5h0Biozt4hmYjxe7upSyC3uPSI=;
	b=oXpNODeMj6rFJVnQik67Gs7lJSvz3cSfpgXhH60bm6ZzFm3G2OOLFXQMb9HxLDOKDb8iCQ
	+y+BcXPgFqsqIYwmLWb133buEt4GsjkRWqFI15qRDz5/zXLnpt6Y6Bgi0d/8+Xkh08MgEU
	xYrkmvH26Wf7AorRyXMy/M3+sijo/k8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGdB8HlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786695739;
	b=rERS1yl0iByhuwtb8hS3PRVcTnT4MPykgyaiKYcCUq9hCH3nBA9X2llX5vD4pGo+nIECRk
	rRf0hPjgpLHSEhYltQo4vcaeM8cuH0e5psnJok1vigHK6a+sa1my62BUIhJMVlPZP8AJnp
	whVxFHOCY5pzzMe1VlfoZky/mZpS3fA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27B1B4018E;
	Fri, 14 Aug 2026 08:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D746D1F000E9;
	Fri, 14 Aug 2026 08:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786695738;
	bh=EIsk+Wf4F0dnluT9f5h0Biozt4hmYjxe7upSyC3uPSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GGdB8HlRdNCLAI/kFaUg6q6hJdlaxu4wqup44Jfwh7ulG3dL4V+hKR2FQeEi4IhoZ
	 aM6+r4s8zYekwBX0+DQlFpQpIbYVJFRhfapJ9Bj63/1pEGSNKhi6liFAdm3Z5q9uM7
	 Y2bnBDJ0EV0k/tKGpsXFNZdsAX9iWoKdmjZWy3nWP6/UmVuejmROjAjj74ocXWYIvc
	 W3QmWkHq6qFWC34U2v64st0h9CWFGP7xx2t1/42JebrcEgsTi2OB5F2Mawkry60k2U
	 /exyBR6Ia9TlU2D5XBkOX9sSIAxkfMMVrRGwuKIze16rjcUQBrGO8kSKa+gFbY+alb
	 5W18TnBeDEpYA==
Date: Fri, 14 Aug 2026 09:21:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: prevent uncharged mremap expansion after
 fork
Message-ID: <an7Emqen9f7W801p@lucifer>
References: <20260813225328.2010303-1-4ncienth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813225328.2010303-1-4ncienth@gmail.com>
X-Rspamd-Queue-Id: D2B9F1C0007
X-Stat-Signature: ryg97m48rereddn8i6dphof9bgkuuf79
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786695739-687371
X-HE-Meta: U2FsdGVkX181E3fGPWyn7pL8GvpwlEOdaDQjqHrOhap02gLg3iT1SxMNYUHWIUB85p26A0cPxZlhQ9XerQHyOCbclMxgEASK2UmJkYRhC+kI0ZWPSI7hXrxUIBvqWDcm//sx+xzYkk3ohy4oH1JshVtp5VkzxY01V1E1lVRUVjw0BaNpGY841gE6iYLoSKieVNHmLcXYLVzg+5YKoV0ST6LSANta14uYPPnV1RqbDQgoibj57TGBiQmf4UHku3weIyifSnKxqkQYcSJ2SlF+dI2WByaFrO8XryQCIiTig3ELZ/IX6SZuJdw4zmqQJwvy7/a0Id5+yKMnN8LAnCT+8V5vr8qgZzD/iPwIXH5sAwG4pryHr3p2AE/0moOAdVgqCFBqRoX9P3m4EGLcYirEhxjSlv6WKpUYu5x+VQCgZIAc5rASgrqjnSxc1cnL79+ViP8vEd6vK6BE/xqoUzpwCkhcPxHYATI4ogKroHkc5awGPbFgf+NtZQJ9uOCZUJopgOdQ32W/qD+wt5wrzXfoUeBwEF8sSKSlty//FnI1V6wx2K7hRJKbyehG3qAJVvhfKf5gtECFZovTvB19RhjuZbrzzoLSYfygpCjuA7G388vFFuBReWEMDqTtyAmiOgVanamcaYpSkdpgd/erU/4WN6/zBh2YZer8itc3KIXONvQcYMRoA43XAbt3iIXx+rgur4Bbc+Oa0HXt6HH+Cihk+NK5RuLP8PG9dJsNsFoV+xBQEpWrv8fLlD2KZ6Ysn23kDHX6/1zb2eWCQwJYON+rOQIygp4aJcpAi7GGvYbx34EcXddjI00681jhcqOmtJBmGN5sHlJrdUmpInXU2eU2K3MGkBuIUjxoaN6sNkz1TVn+CesFrqXJYxx7bfjxgw8OVHpozM4vfZnvaJC+k9y+0OgM3Mk7Wt4AqPbwP0rGqUvoTpGvz4WUVoRIrZABh851wLGAigxQXq0N/p9dzIh
 /ao5gUjB
 ndScVkM4Osfvd+k5QikW5/HfyMPbCQy4on418pdMYNoFb4/X/8cGlzeDNk3NabggLTgp1AIIzp+itB4Uox/PIDzDzZRa9TMDxKfcW1vMIOuf11erDtUGFFTPs+kAlUiWBi35XSiViYcsUDBzyWUYLqQ9jeJOizTR7k5rdcGwr9N6g+c8I+4Ngcqejoo0XE/VkCWjFUcsz0nlEu9EurQhQ8cldYodIPJSlzMv+T6ZXLR06JPVmk+bVBPGMSKDF7of0hY5mwOp4HBjngDCjM/fHKbFIda44sq7HNtnDkjzj630lBxttaAH1rU3RfA1R+L4cX+MV1BXM/C98F0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(I'm going to make an emacs macro to paste this now I think :)

Given it's 2026, you're a [relative?] newcomer to mm, and you've proposed a
patch for a very specific part of AI I have to ask - is this AI-generated?
If so please add an Assisted-by tag as per kernel procedure.
See https://docs.kernel.org/process/coding-assistants.html

On Fri, Aug 14, 2026 at 07:53:28AM +0900, Daehyeon Ko wrote:
> Secretmem mappings are charged against RLIMIT_MEMLOCK and marked
> VM_LOCKED because their pages are unevictable and removed from the direct
> map.

secretmem is weird in that it does mapping_set_unevictable() and _then_
marks things with VMA_LOCKED_BIT.

The description though is woefully incomplete - that should be called out.

I'm not really confident you understand this however.

Though 'charged' isn't really the right term here I'd say.

>
> dup_mmap() clears VM_LOCKED on the child copy, but mremap() uses that
> flag to decide whether an expansion needs a memlock limit check and
> accounting. An unprivileged child can therefore expand an inherited
> secretmem VMA past its limit and populate the added range.

'Unprivileged'? I mean where does privilege come into this? I don't see
capacity checks or needing escalated privileges anywhere.

And forking from a parent process can only be done by err, the parent
process?

And what does 'past its limit' mean? You mean the size of the file?

Well, already:

	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
		return vmf_error(-EINVAL);

Again you are lacking clarity and detail which speaks to a lack of
understanding.

You can already map a secretmem mapping of any size you like, but you'll
just end up the part of the range as invalid.

What I think you mean is only RLIMIT_LOCKED, and the fact that secretmem
seeds its folios as unevictable and uses this as its only limit aside from
memcg memory usage limits?

>
> Add a VMA open callback that marks secretmem copies without VM_LOCKED as
> VM_DONTEXPAND. dup_mmap() invokes the callback after clearing VM_LOCKED,
> while the original charged mapping retains its existing ability to grow
> within the limit.

Absolutely no to this. A complete abuse of the hook and an illegal
operation.

>
> Add a selftest that verifies expansion of an inherited secretmem VMA is
> rejected.
>
> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

This solution is a horrible hack that doesn't really make any sense at all.

You can expand something here on mremap, but I don't see what that would
get you.

The range not part of the inode's size and accesses outside its range would
SIGBUS.

I think what the real problem here is:

- Parent process gets some secretmem memory up to RLIMIT_LOCKED.
- Fork -> child.
- Parent exits.
- Child now has 0 VmLocked pages, can grab more secretmem memory past that limit.
- Rinse and repeat - can ignore RLIMIT_LOCKED for secretmem.

The real charging, i.e. memcg, all still remains correct.

Your patch doesn't fix this at all.

To address this would require some specific core mm logic to actually
ensure the range gets accounted by RLIMIT_LOCKED in the child, also.

I'll go think about that a bit.


> ---
>  mm/secretmem.c                            | 11 +++++
>  tools/testing/selftests/mm/memfd_secret.c | 58 ++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 4877c262cb1f6f..e5878ce91c768c 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -108,7 +108,18 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  	return ret;
>  }
>
> +static void secretmem_open(struct vm_area_struct *vma)
> +{
> +	/*
> +	 * dup_mmap() clears VM_LOCKED before calling ->open().  Prevent an
> +	 * inherited, uncharged mapping from being expanded by mremap().
> +	 */
> +	if (!vma_test(vma, VMA_LOCKED_BIT))
> +		vma_set_flags(vma, VMA_DONTEXPAND_BIT);

This is a completely illegal operation.

You do not change a VMA from being functionally one thing to functionally
another on fork, especially something that makes a VMA have 'special'
properties like this.

And yet again I am reminded what a terrible idea it is to _ever_ pass a VMA
pointer to a hook anywhere.

> +}
> +
>  static const struct vm_operations_struct secretmem_vm_ops = {
> +	.open = secretmem_open,
>  	.fault = secretmem_fault,
>  };
>
> diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c

For future reference - keep test patches to another commit.



> index aac4f795c327bd..3d33487eaaccf3 100644
> --- a/tools/testing/selftests/mm/memfd_secret.c
> +++ b/tools/testing/selftests/mm/memfd_secret.c
> @@ -84,6 +84,61 @@ static void test_mlock_limit(int fd)
>  	pass("mlock limit is respected\n");
>  }
>
> +static void test_mremap_after_fork(void)
> +{
> +	void *mem, *remapped;
> +	pid_t pid, waited;
> +	int fd, status;
> +
> +	fd = memfd_secret(0);
> +	if (fd < 0) {
> +		fail("memfd_secret failed: %s\n", strerror(errno));
> +		return;
> +	}
> +
> +	if (ftruncate(fd, page_size * 2)) {
> +		fail("ftruncate failed: %s\n", strerror(errno));
> +		goto close_fd;
> +	}
> +
> +	mem = mmap(NULL, page_size, prot, mode, fd, 0);
> +	if (mem == MAP_FAILED) {
> +		fail("unable to mmap secret memory: %s\n", strerror(errno));
> +		goto close_fd;
> +	}
> +
> +	pid = fork();
> +	if (pid < 0) {
> +		fail("fork failed: %s\n", strerror(errno));
> +		goto unmap;
> +	}
> +
> +	if (pid == 0) {
> +		remapped = mremap(mem, page_size, page_size * 2,
> +				  MREMAP_MAYMOVE);
> +		if (remapped != MAP_FAILED) {
> +			munmap(remapped, page_size * 2);
> +			_exit(KSFT_FAIL);
> +		}
> +		_exit(errno == EFAULT ? KSFT_PASS : KSFT_FAIL);
> +	}
> +
> +	do {
> +		waited = waitpid(pid, &status, 0);
> +	} while (waited < 0 && errno == EINTR);
> +
> +	if (waited == pid && WIFEXITED(status) &&
> +	    WEXITSTATUS(status) == KSFT_PASS)
> +		pass("mremap expansion after fork is blocked\n");
> +	else
> +		fail("mremap expansion after fork was not blocked\n");
> +
> +unmap:
> +	munmap(mem, page_size);
> +close_fd:
> +	close(fd);
> +}
> +
>  static void test_vmsplice(int fd, const char *desc)
>  {
>  	ssize_t transferred;
> @@ -297,7 +352,7 @@ static void prepare(void)
>  				   strerror(errno));
>  }
>
> -#define NUM_TESTS 6
> +#define NUM_TESTS 7
>
>  int main(int argc, char *argv[])
>  {
> @@ -320,6 +375,7 @@ int main(int argc, char *argv[])
>  		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
>
>  	test_mlock_limit(fd);
> +	test_mremap_after_fork();
>  	test_file_apis(fd);
>  	/*
>  	 * We have to run the first vmsplice test before any secretmem page was
> --
> 2.54.0
>

--
Cheers, Lorenzo

