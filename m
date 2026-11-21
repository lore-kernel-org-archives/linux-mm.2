Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDAFA606A685
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=laXyyUuZ
Received: by kanga.kvack.org (Postfix)
	id ECC456B05B0; Fri, 20 Nov 2026 19:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA34A6B05DA; Fri, 20 Nov 2026 19:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA056B05DB; Fri, 20 Nov 2026 19:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B82666B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:18:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 503FDC0291
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:18:16 +0000 (UTC)
X-FDA: 85457214192.12.F2893D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 917884000D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:18:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laXyyUuZ;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795220294;
	b=b26ZlhsSgU/rBG4J7LgJtOR8Q6UnKz0gfq7FuDKKSGtojmtIvufj2wpWZhaGkpKVQIMjOA
	v0bGTOC1jAiChRWv8leb+95i07gx4F4A1nbqsDYZsZOTPOWbHUvNOPkVAjkv/VE2JFqhtU
	KgKU5mh4lryo0/7BdHbpqmlHfKjjRm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795220294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffPWhV24l7aV34qwodVY7b49pMX0mUgfsIkMN9/2TPc=;
	b=uO7DQBMC35v5ezQBypZum/S1dLW2JILm+Rc+uuF0Me5NIc0ieoxYnmhs1/fbwbaK6mvqGf
	JqQhWYzJI28CHDuW+jefMxwpW1yAIN8K+TsGgW0WKPGsW6BbLteOt/bhhNgcdRhfgbrM20
	EelpcN9LvB4iPlwPd1ychykydLoMs1A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laXyyUuZ;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id BB03045FFB;
	Sat, 21 Nov 2026 00:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE4E51F000C6;
	Sat, 21 Nov 2026 00:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220293;
	bh=ffPWhV24l7aV34qwodVY7b49pMX0mUgfsIkMN9/2TPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=laXyyUuZTT0f1BgWfsRs3hbfvkYEWRTNIHzPq4IJ69OLR0lsi9wF7blAtcps3JLYo
	 dDMN4oi+/CNtoR/45odtOA9HbsLlkq2nyJ5gnGxfOs/7e9fj/YGLaUAjLSUvLULAO3
	 DsLKgXzm1aOVL7r3Qdc/mhGN/rXlUtbtZh8yjmioYivekgq56W+/8pu/DxQROV1KwC
	 7FzIy8hIHURS2EBqZ3LWj9/7tZkgq3x7tgXUidMh14L5rba/b96Sy5fyQLj6CEpkyc
	 TWVmZpBJw7lplo03GrGiIK55vUGWTUVWf9nmwG/aBWWtR5TTxDHbYZpCO8inWg9HhG
	 VdfRBSXOI0Yaw==
Date: Sat, 21 Nov 2026 02:18:09 +0200
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
Message-ID: <awDjQeXjqrhNHoWQ@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-15-jarkko@kernel.org>
 <awDjC9hcKSRnCPgJ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awDjC9hcKSRnCPgJ@kernel.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 917884000D
X-Stat-Signature: huem8ubujax8ysj8tmtq7fkjyc6xpcu3
X-Rspam-User:
X-HE-Tag: 1795220294-460412
X-HE-Meta: U2FsdGVkX1/Uc8qFE4yapmw9OJd8xeaWzaipHgPIqms7f20gagYO9qc/ESaDPUPr6iFvEJb1kaYiFnWw2+1J0GIAWjmnrE+Gvg/CZeODQXjvJ9TqBhJNs/qb7fwYWc9Mo1uTEQTFM+/MOMsIA6dOuYJKb//oHUu97GTvbmLarnZAWl0DSN1kDwSZvRCqa1omPfCB2EpLj/DC4VvYIw3LKNRV6GYDzkI6J1LHro5rQcHoirayadjafyDtFwSQzCxytxgc+CW2EX55yydRDH8VNb9Lg+JgJzIX1RPdl0aDSWsgHFGPWbuo+6/AylVw+1HIlXSGmdX1aCALLmtqUE5jYBXU7jf9L+K7fft0kodLG3Egob9KSbbTjAgh8Niz/z4SRokTbqBHZQYQM4RzoLgs1YJQOHqM/urcmdEk2ZutN9fU75SQntFfygTdUmbVh6hjVKUoGLOP4i1GSHEgVu3QvZ1f/LGctvZp0TFhpCQ9ac6K1XI2BtPDRKkhQhuBpZVNgETilUtLp4l2PvELdJHJgh5oSvX4v/tmbR6rlxwsL0L2lcM89O5WYosxEKSiS572Oy7WXifRCNZNk77H0wtTpco1R8IaGzSiWQcJAKuQlZeHtFlRpVXv2q0Of0sLfu5Pua8fXRvcH7ilNJ8Dp9kGmExAT2XrmSjq1YvZphcLZdlzvd4AfviNZW26n6eulYVQxIffpDuK31+sr/92RastpVWeAC+kqaZlMmfyS1ZmJvU+sS/NUwImgHZ3GRswZZj0a5pGMTETHADXl8NBv+LCXiNITOZ1cxrM4WbeLswsC68SHblCDPwCk359Jjx5pljzf6khNtTKZXCbgFs41pciMBj41j/FhH87pC3oWokUKtIDKMwkofVCZi8yYSKyyLi+uwEwuC9FfdIZ1TjKpaXFZyQY1GCX6QBlFbMo6KoHwc2OxRBx2CJsvaZHJFMZIWopBvT+Su0v29QWLy5CS27
 ue866Q8C
 oKM44Ri9+7vXB9DrqKo9IMLBqzvaxpg9DnXuc9hM7w9siMoD93Vsfo3ZbuHTV2ddjq3+U3yXzwZ5kagWaBFpWSmD1pywiY2F4ElzhbXEOJ3y7qCGOjw4m1Fs2VGnS8uBa9zkSKJn1QlWZuSbaSKGtTNbk/a4d5n+sT4GtrPcGJUdZwMXqPeulSUnVgKNg6d3uCZZbQRA6rbP13LiGsSxk604DGmpWgIZpDrG+3FxK9HdR7plYu53na5WyzI6IPfVbvi9M9HrTsWB1gwcPoNUqfgpi+l7wyxLpYY1Jwy+hwg3leta1J0y4jJTiedr8it99LsQqtA8H6m2RrAYHfDlL8uVcV2XjqxlOUd5eukf5i4gPTlLfXzm8UnxfZrAKXKr1XKHhPyovZMK5ka9djC8s/MwvR0yjnqReFjBlyTp1kTZvEa4Jtggk4Swb3GrLOXA74bkUqbxWBvsZgNzWfsjitH5I1cZdg7w2ab5HZg7ueU1paHJAdjkOaeWM/GxjeWhnmYs2zTla4oaYn1/ytZPIjIt0pToDfhZ7ifDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:17:20AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:33AM +0200, Jarkko Sakkinen wrote:
> > wait4() and waitid() only allow a parent or subreaper to collect exit
> > status, so an external manager holding a rootns file descriptor cannot
> > wait on a rootns init process forked by another process or observe exit
> > status multiple times across observers.
> > 
> > Add the ROOTNS_WAIT ioctl and struct rootns_wait_args to wait freezably
> > and interruptibly on a rootns file descriptor until its init thread group
> > exits and report the recorded wait status. Return the init TGID
> > translated into the caller's active PID namespace, 0 for WNOHANG while
> > running, or -ECHILD if init was never started or is not visible to the
> > caller.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  include/uapi/linux/rootns.h | 26 +++++++++++++++++++++
> >  kernel/rootns.c             | 46 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 72 insertions(+)
> > 
> > diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
> > index bd643bdfb43c..3fd215185398 100644
> > --- a/include/uapi/linux/rootns.h
> > +++ b/include/uapi/linux/rootns.h
> > @@ -8,6 +8,7 @@
> >  #define _UAPI_LINUX_ROOTNS_H
> >  
> >  #include <linux/ioctl.h>
> > +#include <linux/types.h>
> >  
> >  /**
> >   * enum rootns_flags - Flags for rootns()
> > @@ -24,6 +25,16 @@ enum rootns_flags {
> >  	ROOTNS_ALL_FLAGS	= 0x00000003,
> >  };
> >  
> > +/**
> > + * struct rootns_wait_args - Arguments for %ROOTNS_WAIT
> > + * @flags: Wait options (0 or %WNOHANG).
> > + * @status: Output wait status of rootns init in waitpid(2) format.
> > + */
> > +struct rootns_wait_args {
> > +	__u32 flags;
> > +	__s32 status;
> > +};
> > +
> >  #define ROOTNS_IOCTL_MAGIC	0xB9
> >  
> >  /**
> > @@ -41,4 +52,19 @@ enum rootns_flags {
> >   */
> >  #define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
> >  
> > +/**
> > + * DOC: ROOTNS_WAIT
> > + *
> > + * ``ioctl(rootnsfd, ROOTNS_WAIT, &args)`` waits interruptibly (unless
> > + * ``WNOHANG`` is set in ``args.flags``) until ``rootnsfd`` reaches
> > + * ``ROOTNS_DEAD``, then writes the recorded exit status of ``rootns`` init
> > + * into ``args.status``.
> > + *
> > + * Returns the caller-visible TGID of ``rootns`` init on success, ``0`` if
> > + * ``WNOHANG`` is set and the ``rootns`` has not terminated, or ``-1`` with
> > + * ``errno`` set to ``ECHILD`` if init was never started or is not visible in
> > + * the caller's active PID namespace.
> > + */
> > +#define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
> > +
> >  #endif /* _UAPI_LINUX_ROOTNS_H */
> > diff --git a/kernel/rootns.c b/kernel/rootns.c
> > index 5d59fc9a591d..cb74ddc8363c 100644
> > --- a/kernel/rootns.c
> > +++ b/kernel/rootns.c
> > @@ -117,6 +117,47 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
> >  	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
> >  }
> >  
> > +static long rootns_wait(struct rootns *rootns, void __user *uarg)
> > +{
> > +	struct pid_namespace *pid_ns = task_active_pid_ns(current);
> > +	struct rootns_wait_args args;
> > +	long ret;
> > +
> > +	if (!uarg)
> > +		return -EINVAL;
> > +	if (copy_from_user(&args, uarg, sizeof(args)))
> > +		return -EFAULT;
> > +	if (args.flags & ~WNOHANG)
> > +		return -EINVAL;
> > +	if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
> > +		return -ECHILD;
> > +	if (READ_ONCE(rootns->state) == ROOTNS_INIT)
> > +		return -ECHILD;
> > +
> > +	if (!(args.flags & WNOHANG)) {
> > +		ret = wait_event_freezable(rootns->waitq,
> > +					   READ_ONCE(rootns->state) == ROOTNS_DEAD ||
> > +					   READ_ONCE(rootns->state) == ROOTNS_INIT);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	scoped_guard(spinlock, &rootns->lock) {
> > +		if (rootns->state == ROOTNS_INIT)
> > +			return -ECHILD;
> > +		if (rootns->state != ROOTNS_DEAD)
> > +			return 0;
> > +		ret = pid_nr_ns(rootns->init_pid, pid_ns);
> > +		if (ret <= 0)
> > +			return -ECHILD;
> > +		args.status = rootns->exit_code;
> > +	}
> > +
> > +	if (copy_to_user(uarg, &args, sizeof(args)))
> > +		return -EFAULT;
> > +	return ret;
> > +}
> > +
> >  static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  {
> >  	struct rootns *rootns = file->private_data;
> > @@ -124,6 +165,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  	switch (cmd) {
> >  	case ROOTNS_GET_NSFD:
> >  		return rootns_get_nsfd(rootns, arg);
> > +	case ROOTNS_WAIT:
> > +		return rootns_wait(rootns, (void __user *)arg);
> >  	default:
> >  		return -ENOIOCTLCMD;
> >  	}
> > @@ -134,6 +177,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
> >  				unsigned long arg)
> >  {
> >  	switch (cmd) {
> > +	case ROOTNS_WAIT:
> > +		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
> >  	case ROOTNS_GET_NSFD:
> >  		return rootns_ioctl(file, cmd, arg);
> >  	default:
> > @@ -328,3 +373,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
> >  
> >  	return fd;
> >  }
> > +
> > -- 
> > 2.47.3
> > 
> 
> Ought to be dropped but seemed too irrelevant detail for the time
> being.

I mean replaced with a syscall path.

Br, Jarkko

