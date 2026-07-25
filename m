Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81922C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8478E6B0095; Sat, 25 Jul 2026 11:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E2F6B0096; Sat, 25 Jul 2026 11:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736206B0098; Sat, 25 Jul 2026 11:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9C16B0095
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:54:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC14E140304
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:54:02 +0000 (UTC)
X-FDA: 85027745124.17.D77FA8D
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA850A0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:54:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZQjDvkn4;
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994840;
	b=XJPA6noXXLPaj6iZuLRhfoLpdSJDVjT81SXlDIAEvWaDr/Y2/BKfJfkzqi0PLb2tUhY0Nl
	HKh4GKDIwywQ+AJkfvwSr3NomY68tlgnAHhlxwLdqI/1y+R5MGqyrOEnuxJPLGKCiymcnc
	XTJNeLmOjj2o2v4Il5o5AKVeXphBfH4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZQjDvkn4;
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvvy4ZDdcswg3rQnKPRfjVI+F4d66zq2fU5XaCFzDL8=;
	b=0O3DrnSVfTvEqN/eovZ89z1OHGchbNMP/B3lHvQh6aK1Vc5Bdmfo+eFrtVw7VGipuX7C5v
	cwXNkc+5j4ut0U/57rFqY3jAYKIIYs0hmbskwD72FynDEaGEQ5vXy+vPC7aNtGSTkqK0m/
	AFi00cy1NtZok6XpHj5wFCowFlKC5Oc=
X-KPN-MessageId: 0c6d650a-8841-11f1-a5a1-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.6])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 0c6d650a-8841-11f1-a5a1-005056994fde;
	Sat, 25 Jul 2026 17:53:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=uvvy4ZDdcswg3rQnKPRfjVI+F4d66zq2fU5XaCFzDL8=;
	b=ZQjDvkn4iMfo/8VkPSOy8ljjN8hYriXoHoX7gYZsBFcX56/QwrXk8o/0or/YDqGfET+e8cNkBG229
	 32UFv58SwfqpN7VLCDxpPTEmdQqdWUrnUPo0dOx1BlWTHYFX21/biz8vxDlcHtSZTi2G/IQOYJU3g8
	 jNo/F2OpDNmFqUgOdClT7xlTOu8r3uvr1mU6Ysyi2bam5Fa8dFhxN4q4XZrW5LesgBQlcfA2gL8n/a
	 IsO3CRajx87Gt1V9w1i/to3V1x6CjPOCw9brL68wdkokxn0onM1sLdICQbGoHoG7vDJiBapUoxW2gJ
	 tqaKMgzhqtrYkOqXMGjGHsDvywKa7Rg==
X-KPN-MID: 33|SYoO7BKxnSp3q+Q2zAJ+7SXDVW4QgsJw++Dyl3VqxY6PIx6G5hp/NvmtqCLduSv
 E4W+IOvkTuabtk60FNEaL+nVQxHXTfohazi68c5Idzac=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|LdJrb658pFOTEgi/Onzb7Ly4knMgFixcDhSMTOsvwBDK9Z/O/vPiMUddWNpTtMl
 KBOn8kLU42qu8SIAjaWGm8g==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 0c20c08f-8841-11f1-a789-00505699772e;
	Sat, 25 Jul 2026 17:53:58 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:53:56 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 16/24] binfmt_misc: give the parse_command() results
 names
Message-ID: <amTcDFzdK5a2KB6A@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-16-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-16-a162f7cb58d6@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA850A0007
X-Stat-Signature: 4b3d38m58abuhdn8rcy8bswaee54rths
X-Rspam-User: 
X-HE-Tag: 1784994840-410203
X-HE-Meta: U2FsdGVkX1/P2jTdYxPxMF3lHmq2HBygOE2IkRidZy9awPPRUYfGq5A+LdXUa17FiGqrlN80NE6jB+FKTGL1vAXz31vJIHF9tqbhbRf8niei9AFwwujwBIDH3xcBi0oEFj0LOOQM1Lh12NQDZVN23mUmxqBrvwyL0dVYK1VGenAye2ajD3RBWAAAyspmoTZJTdRwB5h4Q+OmU8MRb0Jou2UKRFWvfThquW1/V/Kz/+MvkBmLmssMebg5K89UumSOXQJHIH6muSpLl06IdjAF0tIdJDZDPNjzSgjJctcRrH82/StS+gPc8MWVhKbGXG4v0lnA9ZdWfIS5h1zx0Kad8OWcB6nPAETYTx9Si3FPZgXUylkYboZgGnPr8k22/wBOlBUBhjcgXACtPbc1YVhS4nXoTwe6gyf1iFSCRejuSzyqfi6raXCDWQKckrZ14IYQa6piIEZ8H4wncfHN6jUetmEkg9Dj24jHCO3bZXYbXEbIkH7AapX3IfOb47scprL/T0L/TTqYlCiAS7EDt7rnOl/Jm8RpBFhlfl27dGfKpDruc+t5vifuMsmE7k9IEiGDkwe1tgzja/iVHhUtyQhBgU/MV4WcC6dMxZbanB2G6M0KLzp6PlWZ98NABvBvjcE4NonIfSsE0U4lvPevSlk8p/lg4tYeNUZK6pc+YuV9EXUQshEYwxB3WTBsm6TJ8D32Qn56YEm0iIPFPm4HElMgsBWSP3merA5zuh31QjNyOpTLvb0Hp8aQcW0BZByB87f2JuGh560XkEV4K1u72Pt9H9N2iVnRpQ08e34HM2Xqo1qfPE8b4YEoh/1JslaodmtsOLFQnSsIPSoY8pGZKxphvw6z1AvLuGRqjIKSjRleuKiaW3+MOYS1wh9wAI6Q+7r1fjLKJPfV8GWlYCOepCE/vC4R1ffmUlhBUa27CvtqCViUk4kLOu0O2ZMBkhG4zyYkeYoII4CEV5GvBs4l8op
 C5LACchi
 jamPk5Prs+dSiw/T5wJh020dV65lXIcaj61iEvtCxPszlUMPsBxuoRddD75ibC66qLNLTTXtOYCN93A7yVXPPlQ0rLQ6AXxHJDaU8EjwvdjCAcwOWd6YI+tH+oNO1TOl/gpnAg9qdEA+V9FtblscJOUUCiatRMq/Jtah7i5OV7gbKVCpkcK50ZHSdl5y/tL7nSRWzeBy9fYnlmJ0ne/puWakECRaR4jp4A8zHz7l+VTctN3/IHGCu+Nzp8W3rr76ZLWYG7FW0fwbFxgiMuj9CWbvajU3D4Zb/36NnxvANzZ2xMVgBO5BmdgPgT7iMg6XxjMhHJ93E4eV6Z6F+mvEssEHYeue6J13ykyrmBVDiFB/mHatwiDeXXHKmxWQFGjMFdLkY3wrb+PSdhY/HjScVCwFUzDKQ4vk2xNJX4Fwl84gA3A6/kUm34SA6cpk1wW1UKcSmlLN1yIDuRx4K6GZ3tQQpt4wA8lSerAmSVE7b+bBt77B74MfCb/L/WGMLUxbETq3oLicxr8ExaP4pJD+r1nacsau/5jh6gljis/0HNtSrddNxgcNQLgJwBQ==
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

