Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3F2606A68A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETsWsP6A
Received: by kanga.kvack.org (Postfix)
	id 8B0886B05B1; Fri, 20 Nov 2026 19:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888276B05DA; Fri, 20 Nov 2026 19:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F836B05DB; Fri, 20 Nov 2026 19:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2866B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:17:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29BFF1A012A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:17:22 +0000 (UTC)
X-FDA: 85457211924.24.087FD5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 584BF12000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:17:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETsWsP6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795220240;
	b=U26hoab7Ci5ZZDYQvjTulE+8Mg46TbSaqC02o/ibw5GwIVqW2MeAjpAMARrulOSGnoQkPt
	UKwLXxYUZVlTcLE+WbsvND6+4RFjweU0h1ybG41CYB+Fz789EJ9WrNMe/cP341lDMWTAJQ
	ERyUjWVRFDa3sJzsMeZA5CGFx46D60Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795220240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEn70tv1tCk2ukkH1jBhHBKffDpYRYRuAeEkGin2NqU=;
	b=aZUtpt2WX9eP/eVmr7HXJcZf6WL5FGTCXcxJ1i0zC4tpe/RaW4hg6WiGr0WXi/v6wrH/Gc
	QwgybCl3wr60NqnL4++wWEmHouVFyoG9UBk/DDrNaKKqX8/TqC29ZW2YbkNB1QEGuAVt6a
	70Q6MnfmssO8lDSI6gUHqO6whubqoF4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETsWsP6A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D366161126;
	Sat, 21 Nov 2026 00:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CB651F000C0;
	Sat, 21 Nov 2026 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220239;
	bh=FEn70tv1tCk2ukkH1jBhHBKffDpYRYRuAeEkGin2NqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ETsWsP6AHNHJbGwRscL2DvfHX26AYuoh1QNquJp7jVI5sMeKpNtDKz2tAKn5J3Zud
	 JXfLk36uOX4UHBL4JWqqA/Nx0rJZQlCxFi1lkQHtnEouytFMhUV88/2cwtZvvnc1EW
	 nL7LyVSfmtnN0dQ9rb+1lfeQJJa4XxRUJmu/4reYQlTdvxGVSZRxcFGEGXHCZa0AOA
	 K/h0ycJYeU3AYzhoTmbI9Es1yLLl8XRItcMKjCh87MgFbiMKo+UyQWX4EIL9TqqqOE
	 wgvWDMIPEi6CVs5ybIRFSa03/mO34Ruo7GCtRFy4z1mH34uhMx7vnC01H8tst2nIKR
	 6tgJNMo0prJlA==
Date: Sat, 21 Nov 2026 02:17:15 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 14/25] rootns: Add ROOTNS_WAIT ioctl
Message-ID: <awDjC9hcKSRnCPgJ@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-15-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-15-jarkko@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 584BF12000B
X-Stat-Signature: q9ga1sisjwp8ebjskzxsx8muufk6ppcx
X-HE-Tag: 1795220240-848220
X-HE-Meta: U2FsdGVkX1/fb3fY96DEt7qV19x1OPAm1k+wx/zoVfuD3M+BzXV1lSnBzbiU3YPxYFsF+VDXCQpaPgwGo5rlIB4qCz8HtlpghjYBQRxRoNXBnQH3hzF8RQpd/DXuBmg2NRmJojSyOdV0dMjPLthcwtZheovEJfJbZFv7SUxZiRqx84FGyu/MQxWSZ7xWehhkmm2zBaVf1mSb3q7rrejdugSb8NZ9bJO119hf5FRNNrsXW5rQQzFWMhHRaLvXiZ0S3QfX7acLgMRI5PT0dhpR/PgX0yg2xOSD2FfU7yYJV5e7WfxH7vBEGCJ3PXm6LnhYVK2oVareUTyetFe6ZDSfehTOo9HI1vURIwCGNZr2/f96XaJkcPJG5XczaiO0Ku9wDRaoqlRT0KcwXMavr/hCeSyusRDP1sOzEdgfSCpEZWJjTJxdQxzSEKbwKDKByz11S6U4VRbH+kMAT/qaT0B4AghWXrC3rP2uIzTCWmM3//QVNpu7a/VNB5TDHqh/jQhQyz+EX+yaYB0PYKi5bFnrctRzszSvC9dK8ReB2mimCieUKmAkKyLJt/RbE6rT6vHp1c2m+Ql/X2owJbhO4x+jNbt8pv/HqAMpZXO1wVlj3lyzHQucBvBGowCzzU+tvLgkt4V9m0LCeiQHdOz4be2x+DsuoqCkfA0pIP2H5+8UJNKVoI9MNwcr6HHYxTg9LESgiRjqBvUo+oaBmGcEpHeAwoUREzPnIjrdhA8NjTs9uikAt24p97cKeQNYM+m0Mx3l817YFI3+Yb8tcQJq1cDSi3EIFYP+yeVDY80t+2HTtSX1uG87tacigZduljcuL/YWDYK6gl5RLCiCJXjDTHwI4wEQRr2TkQh7HMY43FzaFq/hZ+WVzDymmZCO39P1JkhUw1yoAn8+Gswpe34gBQLvwTWJbmud8wvAb3QmbAXv9Uz6JIBPXS//SZ8IkpcSefIXOA7w0SsQunA5fcTZJkR
 sYqrz+Lr
 SBSwY/NjbQbVYCdzHGMAkQozmFNAILiwx4RLtwXr7XZD1xc6aklOjfmtkjlJtXNkhqbClaSPKIphuOyxzHCjxr5ANQEmQ625bn2OmCSBQ+jBIYDglYXrLH8hejGM2SBIeA6EEOgnLrlGTp+eBT1gKXUULsxvBsYZbkKolQv5ldp7pW90aQHhmlg4axd+ZTpiLIceGYcIXpzHJdJaILIQEPH46O3AhttsAxOK0mY57CYSjck5zczCJnMe3VRmCaqiJYtNdprsZBBm1PEnnNFtYbCvdCkNsyA/mAJVJxeeKmsKn8hqSg84c1k4MdLV0ChteuU5QMKcEKaU3hynLZGOZZfrvFgNcbHQAmv7sOEJDN1o6/1ikax65zYzuIafPqeKYRX4G8PoUwiC7zggSpa9WTjTKxWaoUtg30McmN6+8zJ2zZtSLCBCasELcer4C3PozrCPgl5n8mVtwprwNdmeOa0d1rBdNL0ZIb2oedcjgChXZC/U9uandpA0iDuTPkaLM0D6CNALT2P/UE7FbDiJV8UICQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:33AM +0200, Jarkko Sakkinen wrote:
> wait4() and waitid() only allow a parent or subreaper to collect exit
> status, so an external manager holding a rootns file descriptor cannot
> wait on a rootns init process forked by another process or observe exit
> status multiple times across observers.
> 
> Add the ROOTNS_WAIT ioctl and struct rootns_wait_args to wait freezably
> and interruptibly on a rootns file descriptor until its init thread group
> exits and report the recorded wait status. Return the init TGID
> translated into the caller's active PID namespace, 0 for WNOHANG while
> running, or -ECHILD if init was never started or is not visible to the
> caller.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/uapi/linux/rootns.h | 26 +++++++++++++++++++++
>  kernel/rootns.c             | 46 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
> index bd643bdfb43c..3fd215185398 100644
> --- a/include/uapi/linux/rootns.h
> +++ b/include/uapi/linux/rootns.h
> @@ -8,6 +8,7 @@
>  #define _UAPI_LINUX_ROOTNS_H
>  
>  #include <linux/ioctl.h>
> +#include <linux/types.h>
>  
>  /**
>   * enum rootns_flags - Flags for rootns()
> @@ -24,6 +25,16 @@ enum rootns_flags {
>  	ROOTNS_ALL_FLAGS	= 0x00000003,
>  };
>  
> +/**
> + * struct rootns_wait_args - Arguments for %ROOTNS_WAIT
> + * @flags: Wait options (0 or %WNOHANG).
> + * @status: Output wait status of rootns init in waitpid(2) format.
> + */
> +struct rootns_wait_args {
> +	__u32 flags;
> +	__s32 status;
> +};
> +
>  #define ROOTNS_IOCTL_MAGIC	0xB9
>  
>  /**
> @@ -41,4 +52,19 @@ enum rootns_flags {
>   */
>  #define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
>  
> +/**
> + * DOC: ROOTNS_WAIT
> + *
> + * ``ioctl(rootnsfd, ROOTNS_WAIT, &args)`` waits interruptibly (unless
> + * ``WNOHANG`` is set in ``args.flags``) until ``rootnsfd`` reaches
> + * ``ROOTNS_DEAD``, then writes the recorded exit status of ``rootns`` init
> + * into ``args.status``.
> + *
> + * Returns the caller-visible TGID of ``rootns`` init on success, ``0`` if
> + * ``WNOHANG`` is set and the ``rootns`` has not terminated, or ``-1`` with
> + * ``errno`` set to ``ECHILD`` if init was never started or is not visible in
> + * the caller's active PID namespace.
> + */
> +#define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
> +
>  #endif /* _UAPI_LINUX_ROOTNS_H */
> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 5d59fc9a591d..cb74ddc8363c 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -117,6 +117,47 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
>  	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
>  }
>  
> +static long rootns_wait(struct rootns *rootns, void __user *uarg)
> +{
> +	struct pid_namespace *pid_ns = task_active_pid_ns(current);
> +	struct rootns_wait_args args;
> +	long ret;
> +
> +	if (!uarg)
> +		return -EINVAL;
> +	if (copy_from_user(&args, uarg, sizeof(args)))
> +		return -EFAULT;
> +	if (args.flags & ~WNOHANG)
> +		return -EINVAL;
> +	if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
> +		return -ECHILD;
> +	if (READ_ONCE(rootns->state) == ROOTNS_INIT)
> +		return -ECHILD;
> +
> +	if (!(args.flags & WNOHANG)) {
> +		ret = wait_event_freezable(rootns->waitq,
> +					   READ_ONCE(rootns->state) == ROOTNS_DEAD ||
> +					   READ_ONCE(rootns->state) == ROOTNS_INIT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &rootns->lock) {
> +		if (rootns->state == ROOTNS_INIT)
> +			return -ECHILD;
> +		if (rootns->state != ROOTNS_DEAD)
> +			return 0;
> +		ret = pid_nr_ns(rootns->init_pid, pid_ns);
> +		if (ret <= 0)
> +			return -ECHILD;
> +		args.status = rootns->exit_code;
> +	}
> +
> +	if (copy_to_user(uarg, &args, sizeof(args)))
> +		return -EFAULT;
> +	return ret;
> +}
> +
>  static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct rootns *rootns = file->private_data;
> @@ -124,6 +165,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	switch (cmd) {
>  	case ROOTNS_GET_NSFD:
>  		return rootns_get_nsfd(rootns, arg);
> +	case ROOTNS_WAIT:
> +		return rootns_wait(rootns, (void __user *)arg);
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> @@ -134,6 +177,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
>  				unsigned long arg)
>  {
>  	switch (cmd) {
> +	case ROOTNS_WAIT:
> +		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
>  	case ROOTNS_GET_NSFD:
>  		return rootns_ioctl(file, cmd, arg);
>  	default:
> @@ -328,3 +373,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
>  
>  	return fd;
>  }
> +
> -- 
> 2.47.3
> 

Ought to be dropped but seemed too irrelevant detail for the time
being.

Br, Jarkko

