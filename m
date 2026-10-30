Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DC0606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hSHEsgsY
Received: by kanga.kvack.org (Postfix)
	id AB6D06B05B4; Thu, 29 Oct 2026 22:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DFE6B05B6; Thu, 29 Oct 2026 22:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4016B05B7; Thu, 29 Oct 2026 22:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A486B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:59:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A92CA8058
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:59:02 +0000 (UTC)
X-FDA: 85377785724.13.F4B0BAA
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf30.hostedemail.com (Postfix) with ESMTP id E418080003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:58:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hSHEsgsY;
	spf=pass (imf30.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329140;
	b=S9r9iiu5NtdQ5rRTNxg0K/avI+oIYikJRUl6tFzbJivP78gEsLr3T6jhwe3hrEFO2lRx/s
	0Spqizd1Dtlqwoq/IBB+t4GUf0U/U6PDCvZWMCsyaJGXtarhwhm/dJjmpJEEZSdTFCYCjC
	2iqQ17rKwnkD5viBlMGB2X5HofuheBI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hSHEsgsY;
	spf=pass (imf30.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/Jd2p/prMhPtETNelJfTcFSgzTHlHRnVEoen9y0JaA=;
	b=yJlV88qz+FY6AnXm4XCNir9ieQ8EWKEMZV59RO+QlMzNQTGvh8Weh6oY834r22AkMGvk0r
	kJ4+vxIQCPOuart3Mva8NcuajYs0bhPdsbn+1YRGLLT1YSDlyW2gClZZ2xQb9ccINQzwv2
	wxVydFt1BvxJgZMQswDlaTLl+zSK4rQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793329134; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=w/Jd2p/prMhPtETNelJfTcFSgzTHlHRnVEoen9y0JaA=;
	b=hSHEsgsYOl/knZoiaKmOo9/szTsdb243LBtAHNpX/8InfeQ+O8kqyPkUuu0Awv2qPGL1dtHu80lxiinShoX3C//q9xO3uJS7nJ9pA7n/Uvoqx9PjlbXVT4MQjJDtbupw0uuaN9Pd4ZUnz3XFWW920V7V0LBApZUCRivWHHA722Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDkufcn_1793329132;
Received: from 30.221.129.214(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDkufcn_1793329132 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 10:58:53 +0800
Message-ID: <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
Date: Fri, 30 Oct 2026 10:58:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ateoxzodapnunp4jsxjscs8ueqye8kis
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E418080003
X-Rspam-User: 
X-HE-Tag: 1793329138-10707
X-HE-Meta: U2FsdGVkX18GfT90t8cj4dA2Ukw4/uoi47V81ExRCn8q0Jh1dn35q8aNcOKpTkywHJSiuIf+jJwbIF/HQYSQqRpdTOhyvb2g6UZhcajmOJO4o8zNK+W8/Uz24uYuPZeDayCmrm8nFwjGT4WPTkKmDoIq6l5UVw48OJywcmhPtVfPICgoRPPQdCEC1zaBfclDcEdFT9dsEXbCL232i6wGKLoF5cXP3mzVyxQu2FvyYyLsZUO7d5NcKXmmKe9x2tt7ilKcNALXp63TU/5jFCFmKPyZvrF4fMaoapEfdJK8odsqIrNRPhMhcWgFbAZCf8TjI/UUUq0yZAcJbYlO1EdrCQsa4mnOGhV46b83kok+LocnrgccF6puxZqujmPz37gRfn0s0KtbERgZrawFoldq/ZSnfdYu10WeTt2fkg2Z8hg8jBk6lXksoSehYfu5lxbcAzdVPbqP4AN5jWzNJr/8N0+RBD7D0Q3O3v+oGeRIryfER2ei/V22iMf05bjQwCF/GVIZzfl5LEwsgOTGflPfoopad0aRcYJMv7XQFEU8c16/HH0sN3HV4xRkVll6MQ7O62KAXZfVE5dJyDAn7/SV/oy8ye+R8IiOUEape946CGXDidmXOUMrQ9M9g4k7yCrrsBnlr9lT3vkxIYIJX9Z9wrVAL73ZbQAcQ2QBBNatowTxPMcc38PF/cK2x/Zt09ndPTkkITlBxKAa+lk7Gboajs4/qMfq3apsiQpC3WWaLnxcf6tdBKEQdgcvPe4QZoiWFrm9wta61VCUFM53T6dJn2Bj4tyquctfqUb1m4KgTj2let6/AMfBVVppMlZZ/lvW2UADWZ181cTiax6CwcZwk1qJpkg2BuvCgZjB4CREaGyZhwGv6JrIIeKjJh+fEbHA2WId7A/xyUIXzFvUy4o4cw9rV2GAnQt5VnCVPYHDWvCboHgdSrtxCf9MT/b8borTtDNgWrpii2rOlrsZO/V
 IIrTF02/
 OCrdxG5fEdL6bADlrFICrno8iNm6ITz5JHVqZWVascMujHXlgqRMs59QJy7yePO+vD0h4hCW52yZuPJV4oN7rDmU6kBwIfOrfCS6hV6ZmNAAhHoSI+rA64HdhddpoUitEQmmq0aARAmatT44x+m7VZRDKMowUZFhHWV2yOpuGoxmBoGHA/PfarVz+aE4NoYR3hY3WP0LvaBSvAoQGm8gQBmgxDXRSWn7IjXUrHFfKAygmx4yUIIHYiuw6+G3YgTkJOV35sNxTUHZpFCpeL86s0uAhxHIX/PffTF0fdHlBMvEXCGilCZTVRG0g5dVNG7nFMllYuNFqNZlMidyAiTdIUEoKJNIPI4bn59MMM1b7D3pl10w4zD6QIZibdONvLJ72+Raa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/30/26 12:07 AM, Christian Brauner wrote:
> ocfs2_init_fs_context() doesn't inherit the current mount options for a
> reconfigure. But ocfs2_check_set_options() insists on exactly one
> heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
> So every remount without heartbeat= fails with EINVAL, including
> emergency remount (sysrq u) which passes no options at all, and that
> WARNs for every ocfs2 mounted read-write. A remount that does pass
> heartbeat= silently resets every option it doesn't repeat, e.g. noacl,
> errors=, barrier= and preferred_slot=.
> 
> So start a reconfigure from the current options like exfat and gfs2 do.
> Asking for a different data or heartbeat mode still fails with EINVAL.
> 
> The next patch stops ocfs2 from setting SB_RDONLY after errors. An
> errored ocfs2 then stays read-write and emergency remount would run into
> this as well.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/ocfs2/super.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0af2245ae303..67283244426e 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1222,6 +1222,19 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
>  	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
>  	mopt->dir_resv_level = -1;
>  
> +	/*
> +	 * Start from the current options so a remount only changes what it
> +	 * specifies, emergency remount passes none at all.
> +	 */
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +		struct ocfs2_super *osb = OCFS2_SB(fc->root->d_sb);
> +
> +		mopt->mount_opt = osb->s_mount_opt;
> +		mopt->atime_quantum = osb->s_atime_quantum;
> +		mopt->slot = osb->preferred_slot;
> +		mopt->user_stack = ocfs2_userspace_stack(osb);
> +	}

ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:

  fspick(AT_FDCWD, "/mnt", 0)        sb_flags 0, sb_flags_mask 0
  fsconfig(fd, FSCONFIG_SET_STRING, "atime_quantum", "30", 0)
  fsconfig(fd, FSCONFIG_CMD_RECONFIGURE)
    reconfigure_super()
      ocfs2_reconfigure()
        (bool)(0 & SB_RDONLY) != sb_rdonly(sb)  -> 0 != 1, enters
        fc->sb_flags & SB_RDONLY                -> 0, takes the rw branch
        sb->s_flags &= ~SB_RDONLY
        osb->osb_flags &= ~OCFS2_OSB_SOFT_RO
        ocfs2_enable_quotas(osb)                -> writes the quota files

The final WRITE_ONCE(sb->s_flags, ...) in reconfigure_super() then
leaves it cleared, because SB_RDONLY is not in sb_flags_mask. The same
falls out of a legacy remount whose flags omit MS_RDONLY.

So it seems we should test sb_flags_mask as well?

Thanks,
Joseph

> +
>  	fc->fs_private = mopt;
>  	fc->ops = &ocfs2_context_ops;
>  
> 


