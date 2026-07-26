Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42235C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 20:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7816B007B; Sun, 26 Jul 2026 16:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A589D6B0088; Sun, 26 Jul 2026 16:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FF86B008A; Sun, 26 Jul 2026 16:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA4B6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 16:50:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA754A161A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:50:23 +0000 (UTC)
X-FDA: 85032120726.12.51DE1B6
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8EADF14000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:50:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZR6jAUFO;
	spf=pass (imf23.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785099021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yiqbmKagn6IAd1xKde9X32jMmpKwE6RTxFUDy3dAT4=;
	b=qVZ6Pz0Chj2JgAjDm2PLYZTCmpbgWOavMYc/3sf1pCaHEkkw3R0anK1Jg28yzXIY5Afx+V
	kHpeJeWJMmzRKKzOvbnhJDZtNI0lyz6ps5XgyyA+rqddwbx7ExQ3H+w+pgIViTWH4bkgTj
	1jWgIZbLqXtNElWyL4JupLPaW9XJwAc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZR6jAUFO;
	spf=pass (imf23.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785099022;
	b=zfy8KBr29XxRxg50zeifXTS2PlIbm+kSt2zxupDRwXUA4ENz3zPXltvSfham4RnY9RXkH2
	j1+9nBHZpjPMerVn+2tK1DxirGN3pKQda4ftkEiVtFl+x656dYJyn3bIzkxJwCuRNSiCDT
	B8IqiAEEHPc/yNBokrSHoaQhygX/smw=
X-KPN-MessageId: 9cafce0c-8933-11f1-8f54-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 9cafce0c-8933-11f1-8f54-005056992ed3;
	Sun, 26 Jul 2026 22:50:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=9yiqbmKagn6IAd1xKde9X32jMmpKwE6RTxFUDy3dAT4=;
	b=ZR6jAUFOK3BStmj2H3L2p0B/Cq5GJKNW8OIEVbmiJRFHGZNuMUWIJRC32xfapIDhe/KRpwA8ERbau
	 OMfYAG+y77JbSgZdBRTYefnpamkgBfN0YDVBuPwdLLZ8JpKdWMDPmhjvAcV2PjQ6YHzf7XhAXuYohs
	 si9SoerYPXMWfiknJ+8rOrRSdH6zEastUpw6qT/IM74ZeAb+a8vjnerSK5CyrSCxcAMCFlhTDe/QCu
	 vFfSEE1Y+WzUoo7IDgBxWb5/DrNH0YgrqeALdGnbH6HKKwjPJNtLUb97onzeDRfxvHQTTFiCTBgUzp
	 dMMxy6qbX4Wxx0BJMSj+gWHP4kksv9Q==
X-KPN-MID: 33|Y0AXcPB6hyAOD2TG/96ENkqIjZJDLd407Q1agGDvyRdLRRntAkCPrqmNlxUdkpo
 YlMl7RIYQLieoktQ9mKFYZA==
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|+Z21vaTBTRuW3jxhHED9DxMsyVH44TvP5PeQHtjC6iHxg4aJKV+UB6e4RPFom8Z
 /XHScnPbe8JOLq4HDlydo0w==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 9c8bc361-8933-11f1-87f9-00505699b758;
	Sun, 26 Jul 2026 22:50:18 +0200 (CEST)
Date: Sun, 26 Jul 2026 22:50:13 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 12/24] binfmt_misc: convert the entry file to seq_file
Message-ID: <amZyqIIbvR8t08HW@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-12-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-12-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EADF14000A
X-Rspamd-Server: rspam01
X-Stat-Signature: zoddscidq96r8ygmjm7okm13s35kc9sp
X-HE-Tag: 1785099021-526499
X-HE-Meta: U2FsdGVkX1/GEMOJLwIrQRcoSrT+SECRjSDkHfHcR9F3KgODCg/Jw2/PYe/HIgTNP18TGYG1ghK/zc1W/40A5L+DWVuhn3NYuZTIxH4kYzkdRgXwjkCwP0NoNqJBVLJg4SmlYY89EzsTXkgY+hWWYMhGSXpyT1xD5+9ffRZ/ueqDN1Hmsy+NE5UN4m1qnnFhQDjDL89N0p5YROGwkItY1QfWYrgqpc1D8xYogbKvVDsNCX1Qk01O7MtdP5C9vqOZMYr5E+1xDBIf0p6dN4xJyvJF8zf27nQ9nG0Kg1zylg4zqbxMgJjTbGQS1aKBgwAQhfJjEXbGl5HINhbhd1fhLbxL5kR8P1KMbeDywPACnqp1FJ2FhazqMQ+2+yMrJUYCrDeG5j8mxwtnGKC2rQToVEkzkruGkLodF7x0W1rCFeQ3F90TGOTTJR2/6e5xvRIJFym75LsQD0KjuNP0lyx2MVP3dwysTry2+S/9u/2G+uqmcqdp7X5J4aH/Gzn3rA7ZkcPwNjMnoRUQv9VuHTOdAdhU580udW2YBbfQ1C7p8q97lyF6ZmNEy2BHf1LaeogMOyuDl+VXC4CoO912NNGC6wuCMc3K1GPRpOOojK4xC3WxIbHlGhBLeZRWcaLEZ4Nm1QQqGgA8xpfnc/CoJMzwLeD1QTvKFQT2+IC+iOUI8fKwriHPmLamsSUrXANKQd4xqpp9Ixz5K0mksTNLajl8aY3byjxYWqErUNH7F3+OmruH415klPWBmoe4NSZNzQhkWiSnqDS6BlxO29X5AnGMRGNCAvX2ryvAZESvSsg6MQOibih7oOW8S16kChArFkyh7h0YLdrISv8ONQec6raRBwL24n+oAvYwco5HLeimlPa7ZTl3mgCUt+zXFEpujFLhZ9wus2v8800wV8Gh8DQn1eRxPMcA/XBe1j74NxdyIgM9Op1aGS0erIw9zZm+WCoVFiLGyyrmHpg3NSLFyHX
 rKgXWvgb
 3J6xRvl6Zn/B1IDuT49HvAGxwmAQrxffbBhrj1sITwSLNY2FL3Sf8stYDYrBalN9qHvgxUmN4I/XZfKQJmc1mzTZOLYdUQ3lgLuJ1dI8C3L+ck2l+q+M32JF3M/Ww2S76OKvG/w2W1+VUolbwF74TT7Z7n5iFT+9YLLOOHNvVYsydhOD387BCtnjal2LHC4VfjFNgy+P0A+5HJn/NTz29Lob49dlDxI6ti1F8hxg7vHn4Pf1dq292wkfoTCoyY0qvGJo4MU/RGtb4bj0A+S98V8wZ3olItcZiRewksS5oZxcgfiG7hLPDoJFaxVsDKZn7xFL8tXAoANaEf/1v2uu16H3hzwacKlQrmvWUZyfU1oRK9V0aWqpLghTWynX6TnbTOQXrsLXD2D5xNHBTxLFzhw2/gbVgAFQ+QCSoiGtGJGGBvujqtGCLa8nABIuEveuAjub96+Lmtfg7Yun3P+W/Mgs5XyAKW9py8KXeEzrvL2lylFGjtgtETOyG8Bz+fmsgCqgGy004vCO+6tFr3Q8mcoG+YbIUdO8vGHY2WAfJ31rzuQ6aR4OplexGoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:13AM +0200, Christian Brauner wrote:
> Reading an entry file allocates a whole page and formats the status
> into it with a chain of manually advanced sprintf() calls, silently
> relying on MAX_REGISTER_LENGTH plus the hex-expanded magic and mask
> always staying below PAGE_SIZE. Convert the read side to seq_file
> which sizes its buffer as needed and gets rid of the open-coded
> pointer arithmetic including the last bin2hex() user in the file.
> The output is byte for byte identical.
> 
> seq_open() clears FMODE_PWRITE for historical reasons and would
> silently turn pwrite() on entry files into -ESPIPE even though
> bm_entry_write() accepts writes at any offset. Restore the flag in
> bm_entry_open() the same way kernfs does for its seq_file backed
> files so pwrite() keeps working.
> 
> The only user-visible difference is that seeking is now bound by
> seq_lseek() instead of default_llseek(), i.e. SEEK_END stops working
> on entry files, which nothing can sensibly use anyway.
> 
> The status file keeps its simple_read_from_buffer() as it only ever
> returns one of two fixed strings.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 74 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 39 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 252e1f2a8347..23a2020d9266 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -12,7 +12,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/hex.h>
>  #include <linux/init.h>
>  #include <linux/sched/mm.h>
>  #include <linux/magic.h>
> @@ -25,6 +24,7 @@
>  #include <linux/namei.h>
>  #include <linux/mount.h>
>  #include <linux/rculist.h>
> +#include <linux/seq_file.h>
>  #include <linux/fs_context.h>
>  #include <linux/syscalls.h>
>  #include <linux/fs.h>
> @@ -577,40 +577,47 @@ static int parse_command(const char __user *buffer, size_t count)
>  
>  /* generic stuff */
>  
> -static void entry_status(struct binfmt_misc_entry *e, char *page)
> +static void bm_seq_hex(struct seq_file *m, const u8 *data, int size)
>  {
> -	char *dp = page;
> -	const char *status = "disabled";
> +	for (int i = 0; i < size; i++)
> +		seq_printf(m, "%02x", data[i]);
> +}
> +
> +static int bm_entry_show(struct seq_file *m, void *unused)
> +{
> +	struct binfmt_misc_entry *e = m->private;
>  
>  	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
> -		status = "enabled";
> +		seq_puts(m, "enabled\n");
> +	else
> +		seq_puts(m, "disabled\n");
>  
> -	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
> +	seq_printf(m, "interpreter %s\n", e->interpreter);
>  
>  	/* print the special flags */
> -	dp += sprintf(dp, "flags: ");
> +	seq_puts(m, "flags: ");
>  	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
> -		*dp++ = 'P';
> +		seq_putc(m, 'P');
>  	if (e->flags & MISC_FMT_OPEN_BINARY)
> -		*dp++ = 'O';
> +		seq_putc(m, 'O');
>  	if (e->flags & MISC_FMT_CREDENTIALS)
> -		*dp++ = 'C';
> +		seq_putc(m, 'C');
>  	if (e->flags & MISC_FMT_OPEN_FILE)
> -		*dp++ = 'F';
> -	*dp++ = '\n';
> +		seq_putc(m, 'F');
> +	seq_putc(m, '\n');
>  
>  	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
> -		sprintf(dp, "extension .%s\n", e->magic);
> +		seq_printf(m, "extension .%s\n", e->magic);
>  	} else {
> -		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
> -		dp = bin2hex(dp, e->magic, e->size);
> +		seq_printf(m, "offset %i\nmagic ", e->offset);
> +		bm_seq_hex(m, e->magic, e->size);
>  		if (e->mask) {
> -			dp += sprintf(dp, "\nmask ");
> -			dp = bin2hex(dp, e->mask, e->size);
> +			seq_puts(m, "\nmask ");
> +			bm_seq_hex(m, e->mask, e->size);
>  		}
> -		*dp++ = '\n';
> -		*dp = '\0';
> +		seq_putc(m, '\n');
>  	}
> +	return 0;
>  }
>  
>  static struct inode *bm_get_inode(struct super_block *sb, int mode)
> @@ -695,23 +702,18 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
>  
>  /* /<entry> */
>  
> -static ssize_t
> -bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
> +static int bm_entry_open(struct inode *inode, struct file *file)
>  {
> -	struct binfmt_misc_entry *e = file_inode(file)->i_private;
> -	ssize_t res;
> -	char *page;
> +	int ret;
>  
> -	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!page)
> -		return -ENOMEM;
> -
> -	entry_status(e, page);
> -
> -	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
> +	ret = single_open(file, bm_entry_show, inode->i_private);
> +	if (ret)
> +		return ret;
>  
> -	kfree(page);
> -	return res;
> +	/* seq_open() clears FMODE_PWRITE, bm_entry_write() takes any offset */
> +	if (file->f_mode & FMODE_WRITE)
> +		file->f_mode |= FMODE_PWRITE;
> +	return 0;
>  }
>  
>  static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
> @@ -759,9 +761,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  }
>  
>  static const struct file_operations bm_entry_operations = {
> -	.read		= bm_entry_read,
> +	.open		= bm_entry_open,
> +	.read		= seq_read,
>  	.write		= bm_entry_write,
> -	.llseek		= default_llseek,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
>  };
>  
>  /* /register */
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

