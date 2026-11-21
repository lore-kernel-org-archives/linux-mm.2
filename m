Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D02A606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9IdaaCN
Received: by kanga.kvack.org (Postfix)
	id 0ECDA6B05B1; Sat, 21 Nov 2026 11:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D476B05B2; Sat, 21 Nov 2026 11:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7EC6B05B3; Sat, 21 Nov 2026 11:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B43516B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:53:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 309EAC056F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:53:16 +0000 (UTC)
X-FDA: 85459721592.09.519B25A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99C3E100007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:53:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9IdaaCN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795279994;
	b=z6x5Six0tXeNOwS6B3qVJovt21cCDeN0244S+dbLJFnqONllEL0+8RFemkbnmHeYOg+/4D
	EbzRIPMUz5l984dD5DOPT9lDKUElE8hK2bZxSYdxEZoD+kypCC6md61zVsfbtTDExmYvq0
	5Z7ioilZuOCbnNxgHe9wZxMJgyWzTnk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795279994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFcqldHucwK+C2tqtdJb8Bb0ObxZeQLB5nFF9Sfrquw=;
	b=pTv2EtdjdxKhzHg1HjG+pJg4A5Y7wLXEpw0me4nHKVXPhna6HWvec4i1QcMInZU9WeYLzi
	QitZZc9nSMzFfYE2iv76A+Pang4zSIJNbfhlcB6RkpZM2t74AShKiqdvF+8GQKUpDKXMpC
	2eY3CAHnYV65VRRA7qDGOcnDwkaq0Os=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9IdaaCN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id DDEE9605E9;
	Sat, 21 Nov 2026 16:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12B361F000C4;
	Sat, 21 Nov 2026 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279993;
	bh=aFcqldHucwK+C2tqtdJb8Bb0ObxZeQLB5nFF9Sfrquw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m9IdaaCNfA/FKNo4j7nuRQr5xyo32XlA8RCYY2dKnBSYFcmuaF2aLNbzQL3Ws+kkP
	 klhDzy0jBMsf66EQCZTW4gvxE19LB1osV4RlDnKF0MtWGjnVgGKkbAm/SosgJcmPqY
	 fTBxLUMMHvfQmcYekBn8TGnpxZ8VTXormf7BCj2a8bBcyCxS/JgvzniPu5woc86O8t
	 4uzUAMnWb4MgbFSHmjSrfmIMp1ed2y9RtTUseHWqPprQwuolv1dB1JRZavj76iHM/R
	 2eS3qc0igRitfQeU9RQaJMi8ey0OnsXlnRwEUPVd4/a42cHQjCDH0xR7EHxsKoWS0p
	 7xGTJTV5mWKRQ==
Date: Sat, 21 Nov 2026 18:53:10 +0200
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
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Message-ID: <awHMdgo7DbzfLXcj@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
 <awHCTNAo9uMakhAH@kernel.org>
 <awHLt1IpLcqxUnDW@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awHLt1IpLcqxUnDW@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99C3E100007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gezyjghwm5rygazz544k9hdgj3qejf4s
X-Rspam-User:
X-HE-Tag: 1795279994-442943
X-HE-Meta: U2FsdGVkX18yAKtI5KEo8SmbyH6vls/9LGhTgXccEU1B75u4BEXd1CQ8TmEeS8WaTPEORZBbi20cMG/0HYgxrCx4wMNKasPm5GGLCtwv5ETulRheCrGjlziFfJIpKzkI7LVs/LlN+4s8hNAr4BLKCRcSfOjr1eqKY4lllihj/z43Y/yeWOCl6zE12J+yFY+Je6D4jNfC72QVuimsNZMLWDxjRwCYT9jHmXLEoBtT5F7FkpGiWg4MruijUkL6Wb+h2urWLJ8o6MegE4mxY4Dff+FHXmnFH0gdT1s6Db1KeC05r6ZuG29KEVZu1YWPw3FJZBMSQN1yrdU41IwJRPgcUg/LlaqnicduDPKWEjXCoBSuQ8Z1G5Ewc+BWtzQ8+QwUMjmpdvkFw7ENMDq7xRvOxvQSV/9ObWllNTBzU3WcDRhK33TVwFhBIomdWVKngJPgWXIQMkfzpI6gDEppglaV4kp4EtLrKRE/1z2wtRAR7kVpkSAeMtusyMIt1iWsli3mnkkee/CeFDYmgs0rK7wt6ieMp7YlhRgP5r0CNZLBadSTCaHHmyGqZW4uq1WYqolVe3He0h7oy+mkWq5Q+txwz3Rgdne6dphWCeQ5TvbnjGe9yDTa9u0nxbQmh2P1mhc5aPc3qcusnk9iwBOpFIvdkRtSvT+6QXZShXDGvC39jGwxeEdbfY66TDmhd+JSqRx0Q00QlA+ZsmJXWZtI/y9X5srpzHqB6CKESX+NgCgrPHJG7/p0YFFd3+3ktek88vgCbfZ/QsIVZfRewqN+EDJMlj23sCwBAB+6LgWmFh8253Mtdr631MHadhD+5E63fEWKsKAf4MYpX/A0IxrTk5+Ytgh1/QhZ34ix+AHkECKPlyBKUw0HJPZR/IktLlr4ioumdQZXSxo7+anwMglpjy96GfkKclhG226RP9iP8u+ZNmvkuUus3ax+4D2Xjdbwi2aPSqzFq3GfdbfM0nU7v+9
 8D84XxjA
 FlN/d9Dxe29zHXrqYc7KDTvrYedHGZ1OhKZHIows8oyetIiK5fAAeJobsmhkUOaCjly+lmalCgcAGjTUfri51CLqd0VGLanJMMEZYc6qWZLPBF/p+eIIIUk4pZkJMf+OL3OSe8yPXWMHKX8pyEUW1ozyDeOC9xKXnS0LyR0WTxkYxhDuIbzrAGAYXLtlZfYblGQAKUk2kpbvQQXQW+i3ZAbLJTJu/zFsaa5h1Oe2V+pwpTYGBulXplrMJ99K9x07noMYZ1x64+8EHtuEXqRPwWuznawovghXC0tQlA+qrzr7A+AU90jf9nIxcqv87SpeA0aqcnQmQEhZhSmg1nlR4PnXUawshb0Qr8dElmwl5gsDRLg4y6CJKYq0id2ukqmxQRcyezYQjQA/Z6EsitpLUc8wkcFZ2olK0ZBZduvHkxlGkEeCHLte2JFGjhuJMfhfXwiwliqjUbXAOZxBl1x4H7d/nIa/tQrPl24zTlYOCPoY0RumuGCAlUZLBBL/yeUdk73+0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 06:50:03PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 06:09:53PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> > > Configuring UID, GID, and project ID mappings currently requires writing
> > > formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> > > which depends on a live task in /proc and enforces write(2) file-opener
> > > CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> > > file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> > > mapping helper.
> > > 
> > > Add userns_set_idmap() to atomically configure setgroups policy and UID,
> > > GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> > > descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> > > either the caller's or the file opener's credentials, and check parent
> > > ID-range capabilities strictly against the caller's credentials.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > I'll remove the flags. I forgot to remove them from final version.
> 
> userns_set_idmap() still has flags-parameter but it is gated:
> 
> 	if (flags & ~USERNS_SETGROUPS_ALLOWED)
> 		return -EINVAL;
> 
> And used as a bitmask:
> 
> 	ns->flags = ns->flags & flags;

SYSCALL_DEFINE4(userns_set_idmap, int, fd,
                const struct userns_idmap __user *, map,
                size_t, size, unsigned int, flags)
{
        struct uid_gid_map new_uid = {}, new_gid = {}, new_projid = {};
        struct userns_idmap req = {};
        struct ns_common *ns_common;
        struct user_namespace *ns;
        unsigned long old_flags;
        struct file *filp;
        int ret;

        BUILD_BUG_ON(sizeof(struct userns_idmap) != USERNS_IDMAP_SIZE_VER0);

        if (flags & ~USERNS_SETGROUPS_ALLOWED)
                return -EINVAL;

        CLASS(fd, f)(fd);
        if (fd_empty(f))
                return -EBADF;

        filp = fd_file(f);
        if (!proc_ns_file(filp))
                return -EINVAL;

        ns_common = get_proc_ns(file_inode(filp));
        if (ns_common->ns_type != CLONE_NEWUSER)
                return -EINVAL;
        ns = to_user_ns(ns_common);

        if (!map || size < USERNS_IDMAP_SIZE_VER0)
                return -EINVAL;
        ret = copy_struct_from_user(&req, sizeof(req), map, size);
        if (ret)
                return ret;
        if (req.reserved)
                return -EINVAL;
        if (!req.nr_uid_extents != !req.uid_extents ||
            !req.nr_gid_extents != !req.gid_extents ||
            !req.nr_projid_extents != !req.projid_extents)
                return -EINVAL;
        if (!req.nr_uid_extents && !req.nr_gid_extents &&
            !req.nr_projid_extents)
                return -EINVAL;
        if ((flags & USERNS_SETGROUPS_ALLOWED) && !req.nr_gid_extents)
                return -EINVAL;

        if (!ns->parent)
                return -EPERM;
        if (current_user_ns() != ns && current_user_ns() != ns->parent)
                return -EPERM;

        if (req.nr_uid_extents || req.nr_gid_extents) {
                bool file_ok = (filp->f_cred->user_ns == ns ||
                                filp->f_cred->user_ns == ns->parent) &&
                               file_ns_capable(filp, ns, CAP_SYS_ADMIN);

                if (!ns_capable(ns, CAP_SYS_ADMIN) && !file_ok)
                        return -EPERM;
        }

        if (req.nr_uid_extents) {
                ret = parse_user_idmap_extents(req.uid_extents,
                                               req.nr_uid_extents, &new_uid);
                if (ret < 0)
                        goto out_free;
        }
        if (req.nr_gid_extents) {
                ret = parse_user_idmap_extents(req.gid_extents,
                                               req.nr_gid_extents, &new_gid);
                if (ret < 0)
                        goto out_free;
        }
        if (req.nr_projid_extents) {
                ret = parse_user_idmap_extents(req.projid_extents,
                                               req.nr_projid_extents,
                                               &new_projid);
                if (ret < 0)
                        goto out_free;
        }

        mutex_lock(&userns_state_mutex);
        old_flags = ns->flags;
        ret = -EPERM;

        if (req.nr_uid_extents && ns->uid_map.nr_extents != 0)
                goto out_unlock;
        if (req.nr_gid_extents && ns->gid_map.nr_extents != 0)
                goto out_unlock;
        if (req.nr_projid_extents && ns->projid_map.nr_extents != 0)
                goto out_unlock;

        if (req.nr_gid_extents) {
                if ((flags & USERNS_SETGROUPS_ALLOWED) &&
                    !(ns->flags & USERNS_SETGROUPS_ALLOWED))
                        goto out_unlock;
                if (!(flags & USERNS_SETGROUPS_ALLOWED))
                        ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
        }

        if (req.nr_uid_extents) {
                ret = prepare_caller_idmap(ns, CAP_SETUID, &new_uid,
                                           &ns->parent->uid_map);
                if (ret < 0)
                        goto out_restore;
        }
        if (req.nr_gid_extents) {
                ret = prepare_caller_idmap(ns, CAP_SETGID, &new_gid,
                                           &ns->parent->gid_map);
                if (ret < 0)
                        goto out_restore;
        }
        if (req.nr_projid_extents) {
                ret = prepare_caller_idmap(ns, -1, &new_projid,
                                           &ns->parent->projid_map);
                if (ret < 0)
                        goto out_restore;
        }

        if (req.nr_uid_extents)
                commit_new_idmap(&ns->uid_map, &new_uid);
        if (req.nr_gid_extents)
                commit_new_idmap(&ns->gid_map, &new_gid);
        if (req.nr_projid_extents)
                commit_new_idmap(&ns->projid_map, &new_projid);

        mutex_unlock(&userns_state_mutex);
        return 0;

out_restore:
        ns->flags = old_flags;
out_unlock:
        mutex_unlock(&userns_state_mutex);
out_free:
        free_new_idmap(&new_uid);
        free_new_idmap(&new_gid);
        free_new_idmap(&new_projid);
        return ret;
}

Br, Jarkko


