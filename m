Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E738C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16F76B008A; Mon, 13 Jul 2026 12:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA08E6B008C; Mon, 13 Jul 2026 12:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AC36B0092; Mon, 13 Jul 2026 12:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04256B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:12:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 185E08C60E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:12:26 +0000 (UTC)
X-FDA: 84984245892.17.6AE475D
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id DA07FA0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:12:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=S2SDCAzi;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959144;
	b=ddjsryyzS0UOjcPXG+o63sZHqEYCDsGexPm32demqd57On/ocWh6SgJ3UWG6Kx10H7erST
	HvkWAGE9a3AGLC2lvvZ81xwxCw6nwtFUZb7S81QOh6qpm7CQ+zgLj1REAQPnKX8Ni0g5/1
	yKAM2YERIp43dq6uAqyvqjZWTMVseQU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=S2SDCAzi;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uvvy4ZDdcswg3rQnKPRfjVI+F4d66zq2fU5XaCFzDL8=;
	b=FoMtkkEXzq8DTdkzS+1vvBpYI6IKcHCMB16xRB4KF1wrikpfqtGLNh2q5s71J/5Suh5gyl
	6lwJpam7hrCan9RSUQrKbZQeHPFWWGZFZDN/DW4WWe9SwKKN3F1PjveWY3Q2WUx8cKloAW
	VmKpvwFpI4SHn6157iMN9I4TBL0ov6Y=
X-KPN-MessageId: a14ea19f-7ed5-11f1-8f54-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.191])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id a14ea19f-7ed5-11f1-8f54-005056992ed3;
	Mon, 13 Jul 2026 18:12:22 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id a14db61c-7ed5-11f1-91b9-00505699891e;
	Mon, 13 Jul 2026 18:12:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=uvvy4ZDdcswg3rQnKPRfjVI+F4d66zq2fU5XaCFzDL8=;
	b=S2SDCAziLAg9r6MWME/lYJLz90ofesNJ9FnKgoBO2/CqTZYt4c5nkZAYCxhctvAJA2ZNamxuBBY+A
	 DmSk51UKtdnHH66U+J0aWGPud6BbrxOzutdTC4LaAOL4TY6E3MNKMMwcwCaOVseMNjyM9Bx1XsvWNn
	 8dawoTp8Tg1NymEB1c2Z7eYh5U9QUJML5jYSFfOa3KDjxbU60dAslnGEvMVeCs2wdO4mcaI4ndP9H2
	 tT0ua16OY/cTxVEd98XRaJoBhSV9rMhHezzZ1Uc9oVgm/8YuusghZB6zrKqSY+CWF7mz34R/SLI/14
	 39cDQH+pmq1moOR9HHRVWyVXKuEiNxQ==
X-KPN-MID: 33|+HnMd0YcGAo43cmLofG/obfA3lAPoEC9NW+TSFQUqLvyN8oiggDPo+ZoHf22YiG
 Fl4H6uCM97Ey8qxMiikQ0cA0MrAW5G0LtF+vrxJSO+Vw=
X-CMASSUN: 33|4agQlQn9Wb+VDsb/w2xyquW+nvSXN/XdwAQkvHi2aFgNCaKQ6CU4ZtHKcel4PqX
 CZknQFRghithrtUyHbbv3hw==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id a1420070-7ed5-11f1-916a-005056995d6c;
	Mon, 13 Jul 2026 18:12:22 +0200 (CEST)
Date: Mon, 13 Jul 2026 18:12:22 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <1234615100.876439.1783959142374@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 16/24] binfmt_misc: give the parse_command() results
 names
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspamd-Queue-Id: DA07FA0004
X-Rspam-User: 
X-Stat-Signature: jdsqwsbo8n7mmk7j3horm8jjih1yekr9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783959143-951211
X-HE-Meta: U2FsdGVkX19VPPJbr2NZqZetKoWmaCmTqoH6+g7IEytM7rJ7HrzB3JYa/U0lpDGKTPTONa3PR1hn4xRKuVPmDTmtALzVo3Iw8goxDYwJtgXMvh1hZCMls4ilNGvDacXb9Vf8appnqaoZTUPYFmPwRoFfigFqY+NndkTDsl6+Wz/64vDyebWz+TCz6qyEmLOKbGGyh1i8KlLGPumCa+7eAxZyAm9+KIGtLWnBLFz4ZCqu3LBerfbIkDfhp8oL/mFq+SAvO0NhjHgYugtIont63C3g5d4OHIQNAnrw5biJxTvAjgtl4gneEzpVD0YzSsC3oJ1ZyKVUCCJPR9Te39Lr4wmPhJIWk2WmTF/bnBcuBSKcemolJKjRgdethV6QFGj9Anu/J6jGLxTssNnC0d5HVdsBLJlBhm380Dlxn8WEX8eMekpdUbV5+1q4V+HRAoRijpCbyVAfV4+aoUWtS9T4uFd7QMtm3H8pwp4a3bswLehe0K6e3pBn0zwe+4Qj4audJyuYDB1GePBE9cGrtaa0N1FudQcZGoRzi2pHF0Z57u0UcGBm+nGw8WOugIVk7A2l1zjbgQMTmcl3XunMzaBWqTDBc1Xux+nTW+WPCtHhqdhEuK/MRFEEDL9a1+ynZFQ4sQupkHRKPRShW/rpwjYeOIf+wL4gwJbMFiTZXa4RVyJb0myvimV+zhyMGItMWLm1FtfgayDGIV53zFj3ni3QGIj2Hj0yuyJIxKF0sQsbjfC7xngGI7dLIxm3MBsfMf4TS3jFMYvD2a4xtYXi/VcsZKRrXqw98B9uMrfegZZNLi844tcla38FCwLE93zIQkLR/cz9JMVsTHmMsPdWRWVE3NuLgSx3cApJuT1ORN1FxSIPlcP8HKZUGOZsUGdbUXCdZZQkZ8rkvliA1/e+onIy1uoP0itFyaYBzlUypZTcyI6qOGxIr+D/xJF0kJwBh14jGCC9ILEinFLMwIGRUCe
 3GIDoTE0
 BzVO28T8v63YKhnU2T+fMYwmyTCBqLZYlrNIWgyqggbjLy1MRIT8V/5US1zvvoE0nSbp8+mf+TCbA4hpIKIW4Z5eZpw+0k41YPh2pWdE6LdUQxkoMkVEvWn9aK/BC66iEnh0qmPH9dKv73DqZ5+kp9krPJLgBMN/O4+sCUviULjxNuIc7/DWuVqO13tS3+WEeA/Cop0YF7/F60424r93wYKp3CfO0FJuIaw/T5ei87UsZkrbjr2TyAOf1OBpPKovoF5DhaD48FEinWsynfBD0aThvcaGvLO2I0p9e9i50baq+HeONoHOyyJPOckCjovsmzMMU9GblbyNxqtIGldeoE/y+qHjYu10dsBKXlBLGTsiInyU2TJQFNN2CB/UaOQTcYXT562Aqn3QdgmaAo5NIhjYDdO7RD7CDWBwlpYQcTB3FOlnL3TnBEX9qdeGEm/An7+Y9qF05hr7KWtta5tflA/JoTJFlFX0FTm1UTslm5eLWitf7UN5xgigjVwK3qSES50fkfZieN26qfOXRh2VeuLRBVDdnJ6DhvWoZBHSGI5eKmAOujCtCatJD7Io6e3LY1GTBXBsToTpa8Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:17AM +0200, Christian Brauner wrote:
> parse_command() maps "0" to 1, "1" to 2 and "-1" to 3 and the write
> handlers switch on those bare numbers, leaving every reader to redo
> the mapping in their head. Name the commands and drop the per-case
> comments that only existed to translate the numbers back.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 06f4849cf1ad..1f2b1d136819 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -543,9 +543,17 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  	return ERR_PTR(-EINVAL);
>  }
>  
> +/* Commands accepted by the /status and /<entry> files. */
> +enum bm_command {
> +	BM_CMD_IGNORE,	/* empty write */
> +	BM_CMD_DISABLE,	/* "0" */
> +	BM_CMD_ENABLE,	/* "1" */
> +	BM_CMD_REMOVE,	/* "-1" */
> +};
> +
>  /*
> - * Set status of entry/binfmt_misc:
> - * '1' enables, '0' disables and '-1' clears entry/binfmt_misc
> + * Parse what userspace wrote to /status or an entry file: '1' enables,
> + * '0' disables and '-1' removes the entry or all entries.
>   */
>  static int parse_command(const char __user *buffer, size_t count)
>  {
> @@ -556,15 +564,15 @@ static int parse_command(const char __user *buffer, size_t count)
>  	if (copy_from_user(s, buffer, count))
>  		return -EFAULT;
>  	if (!count)
> -		return 0;
> +		return BM_CMD_IGNORE;
>  	if (s[count - 1] == '\n')
>  		count--;
>  	if (count == 1 && s[0] == '0')
> -		return 1;
> +		return BM_CMD_DISABLE;
>  	if (count == 1 && s[0] == '1')
> -		return 2;
> +		return BM_CMD_ENABLE;
>  	if (count == 2 && s[0] == '-' && s[1] == '1')
> -		return 3;
> +		return BM_CMD_REMOVE;
>  	return -EINVAL;
>  }
>  
> @@ -717,16 +725,13 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  	int res = parse_command(buffer, count);
>  
>  	switch (res) {
> -	case 1:
> -		/* Disable this handler. */
> +	case BM_CMD_DISABLE:
>  		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
>  		break;
> -	case 2:
> -		/* Enable this handler. */
> +	case BM_CMD_ENABLE:
>  		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
>  		break;
> -	case 3:
> -		/* Delete this handler. */
> +	case BM_CMD_REMOVE:
>  		inode = d_inode(inode->i_sb->s_root);
>  		inode_lock_nested(inode, I_MUTEX_PARENT);
>  
> @@ -866,16 +871,13 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> -	case 1:
> -		/* Disable all handlers. */
> +	case BM_CMD_DISABLE:
>  		WRITE_ONCE(misc->enabled, false);
>  		break;
> -	case 2:
> -		/* Enable all handlers. */
> +	case BM_CMD_ENABLE:
>  		WRITE_ONCE(misc->enabled, true);
>  		break;
> -	case 3:
> -		/* Delete all handlers. */
> +	case BM_CMD_REMOVE:
>  		inode = d_inode(file_inode(file)->i_sb->s_root);
>  		inode_lock_nested(inode, I_MUTEX_PARENT);
>  
> 
> -- 
> 2.53.0
> 

Good clean-up.

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

