Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5BC606A33F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lev9yW6T
Received: by kanga.kvack.org (Postfix)
	id 2F89D6B05B5; Fri, 20 Nov 2026 20:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0626B05B6; Fri, 20 Nov 2026 20:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CBB6B05B7; Fri, 20 Nov 2026 20:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 028546B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76EF2120293
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:18 +0000 (UTC)
X-FDA: 85457342796.17.A611C5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D6CD80005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lev9yW6T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223356;
	b=iiGopAhOsYSzk8VEieiRqqJl9cRSaFZcsf2zRkDy8AqiZNxUmo4HTeOS5PuUe6jyxZt9V2
	bKO9SGMxFtkYWQCQ46BoTRn6mjxYqMc7ffHL1LiQ928rKb0oN3q7bYCzc4x/TuNJEU7jiU
	wpiH7/o7Sou2fzAk8HljrW0MAPCpxWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dq4uYrhSligK2Yc6yPFlriNqvNi/HgVAWMNzxpJUth0=;
	b=eD/PzlXv5RaddAY/zE4TROe8S7fuADClXyQ/d5jmKCJFcwcMLY5GEnfgy7zyQkysmBbfA+
	BReaYRS1nhqmYvpRDDmd5sW490mSzhBfZnJ0d275Dh/MlIGacg++oqJjtU+Y9gPNYSOJ3T
	7x4pTSs9XdOz6PoGtKMQ6fqzd+ySwbM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lev9yW6T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 84E1860F08;
	Sat, 21 Nov 2026 01:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4AB11F000C4;
	Sat, 21 Nov 2026 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223354;
	bh=Dq4uYrhSligK2Yc6yPFlriNqvNi/HgVAWMNzxpJUth0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lev9yW6T0RvL4iasvGrmNZTk4lNhOVNmBrF/T7i35at+a3FTHi7tKpepvNL2D7KTB
	 h0qDHLVue1JtkmyMZAHextD2GwOh4MT4ACttjuSgzOVEgr60lATGlJCU7IgUKx3fkQ
	 le6QElebQWnly9BHqqJBhk0mfDgCU4zh0d/cQGDUMeLmg4jEkVMHB1zy6d3QAGxqyV
	 O6YA0FvNSKhchFW6WlOSPRgLScQNvnzgAhLBKc9hq4A9SyGetfcf1watb19WTJdnrH
	 thztGrMxm54eA2/KEIAK0nkjpjH+bPpf3ylKRyhPpB9EbRccri3kJABFowAFM8KaY2
	 2lxX87Owry5ng==
Date: Sat, 21 Nov 2026 03:09:10 +0200
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
Message-ID: <awDvNgCFnMhOy3Y5@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-15-jarkko@kernel.org>
 <awDjC9hcKSRnCPgJ@kernel.org>
 <awDjQeXjqrhNHoWQ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awDjQeXjqrhNHoWQ@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D6CD80005
X-Stat-Signature: ounqb5kd1dzbqkzs7egfmexwmtywoj6b
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795223355-712366
X-HE-Meta: U2FsdGVkX19HIvBf9qTqQF21tDGns8gk/Bm+cAKN9TWhUwfUWoOejUFg+5Xoj76VsDymVofggAjK+suhE5bQRqUNqdxuUMETheiMoDxfbVs92ZHUvGpCkl72nVcYRNdfDCRF3261Ln47FDnoMLSc5F4FMHQeduZ4Qei8YMQMDga73reZK5+jiwRomNHc7ja7NJ1UMfufegIktUm2hgNR6F+kzHC9kMXyCWpM1jSVvAuet7M2rDITTGKpCsbpqTU6YeIrOZzbvjk5Ne7Smusl7VWe5wiLsNMf/G2S9KUVMxukoy+w/ryIpf8mBftqInRYvXP+sxcGyPwPNjUD619dy1YOzfhtD6zRBCNswOiyxn9YEdUBsSUgLFpaUVxIZlVMuUHfGLz3zu5IJSUDFDjLc7sQwyjVAGkufmeSzv5vMx9acRKVRC6l4ZhFNptOzWfpRICslscfmc02jLyh1ZQdy6BpC/muC9qmzId3FB6SIuLaVFM5WfGy5WIcAfZZ7fWHO6IHH9VBl3crAdQulswDjndQMoMQqmlvC/SOMDQc3rQ8ma9yCp0iI8FzTDelKQCdEbWYFZrFApsZc+6aAxH0Lkkp7jCOU/urEcz6plkdy4wpfdtt+4hLBFgjG9v/+xuZPtw8yAen9bRW9zR7KiKNJaqpyuA1uy1Lt+6dudhOVdNvoLyYgTwiQxCuBCX2RqRmGijQlyXvrD82aNSYi9VzpJzEO74iT+ORabPPnkm1daD/OOZTfcBlcujrj2HyZSV2gtsS/GFgDZ+Cvx8XP00jvG5kZRqxvNMfhkaGVuXBbCy3Xa4qrl9/V2C2gMKD64vYrqNXPLBnZ4Hi9lJVX/8bwC74mwo1MzILZG1m/vEkZ08y0WW+GuAdSCgzgQR+1f6RDsjsfdh8qlNY3x/CjY6TYYlLj+F3KLCCllNvSxp7HOPGh/a25R3t16gb2uwNd+n0SSFCm5i1kmO0VgUnKKL
 USCVgMTs
 pQF+She+f1u2Q59/zO3qUmu7meOz39IWHW6gGXV4SjonKjj+ykJ/ev+9DEU+ZTMb4vRhJZdjYKzMbixMMerOsRp5VxvAmsq6792FbSxCJmFBxP9fFd/GPRySnRXPflLtOsX0J8lCZCEOVz6HyvZKKtjKeLXQqwQGgU+MEajqBvPTHMxteDnuLNL/RxqwM2+YWSwplwNJ4HceX3Bv+UGxNEXWJEdQjYBh2c0u3I6b2FwJqNOEjKuGAOK0bq53fUjAZjc+4eT+RGnK3QG2wVGgKEl78vtsG/n+xyjkjXb5EAGez8uI+akFzENduUthEgUtW/xR3/xtT1CUk39i1bO55HvPE3bJgg3i0EnSQAOq1s5A1RKklRrBTLVMUkTymZgGESbgg9zVhEut2KFARLMx9L9XWpIAqgSC3rpTHLGaS/wOJfHARQyIw9DU0dLmubENdcBWUgYA6qKrdV/BfVItT6ndhv4DlSL45jPvZby7FgmrnHL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:18:14AM +0200, Jarkko Sakkinen wrote:
> > Ought to be dropped but seemed too irrelevant detail for the time
> > being
> 
> I mean replaced with a syscall path.

Yeah, a lot better overall (less fallible paths).

+long rootns_waitid(int upid, struct waitid_info *infop, int options,
+                  struct rusage *ru)
 {
-       struct pid_namespace *pid_ns = task_active_pid_ns(current);
-       struct rootns_wait_args args;
+       struct pid_namespace *pid_ns;
+       unsigned int f_flags;
+       struct rootns *rootns;
+       bool nonblock;
+       int status;
+       kuid_t uid;
        long ret;

-       if (!uarg)
+       if (upid < 0 || ru)
                return -EINVAL;
-       if (copy_from_user(&args, uarg, sizeof(args)))
-               return -EFAULT;
-       if (args.flags & ~WNOHANG)
+       if (options & ~(WEXITED | WNOHANG | WNOWAIT))
                return -EINVAL;
+       if (!(options & WEXITED))
+               return -EINVAL;
+
+       CLASS(fd, f)(upid);
+       if (fd_empty(f) || !is_rootns_file(fd_file(f)))
+               return -EBADF;
+
+       f_flags = READ_ONCE(fd_file(f)->f_flags);
+       nonblock = (options & WNOHANG) || (f_flags & O_NONBLOCK);
+       rootns = fd_file(f)->private_data;
+       pid_ns = task_active_pid_ns(current);
+
        if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
                return -ECHILD;
        if (READ_ONCE(rootns->state) == ROOTNS_INIT)
                return -ECHILD;

-       if (!(args.flags & WNOHANG)) {
+       if (!nonblock) {
                ret = wait_event_freezable(rootns->waitq,
                                           READ_ONCE(rootns->state) == ROOTNS_DEAD ||
                                           READ_ONCE(rootns->state) == ROOTNS_INIT);
@@ -154,15 +191,23 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
                if (rootns->state == ROOTNS_INIT)
                        return -ECHILD;
                if (rootns->state != ROOTNS_DEAD)
-                       return 0;
+                       return (options & WNOHANG) ? 0 : -EAGAIN;
                ret = pid_nr_ns(rootns->init_pid, pid_ns);
                if (ret <= 0)
                        return -ECHILD;
-               args.status = rootns->exit_code;
+               status = rootns->exit_code;
+               uid = rootns->init_uid;
        }

-       if (copy_to_user(uarg, &args, sizeof(args)))
-               return -EFAULT;
+       if ((status & 0x7f) == 0) {
+               infop->cause = CLD_EXITED;
+               infop->status = status >> 8;
+       } else {
+               infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+               infop->status = status & 0x7f;
+       }
+       infop->pid = ret;
+       infop->uid = from_kuid_munged(current_user_ns(), uid);
        return ret;
 }

Br, Jarkko

