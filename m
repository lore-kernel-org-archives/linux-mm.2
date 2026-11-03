Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0C4606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HVwwGpgK
Received: by kanga.kvack.org (Postfix)
	id 7CEF96B00EF; Tue,  3 Nov 2026 01:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7802A6B05B1; Tue,  3 Nov 2026 01:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F926B05B2; Tue,  3 Nov 2026 01:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38CE46B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:54:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503D31202AB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:54:38 +0000 (UTC)
X-FDA: 85392894636.11.150D41F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7EE2C40005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:54:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVwwGpgK;
	spf=pass (imf07.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793688876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI+R0vssS3+rBEwGlEmrhAJtAWwC+K6R2fL7Q2wxluc=;
	b=QEYVd8lVOEUFbzd0IJMdmS7L2sDlQRVPtWmh8e+8tWSwIFwSy70CevJM156SS5WP1z7gZq
	cc7SXQxqKUXv2hLKjLHEof1oIh8OxZBaoT3Su5oQaSH65VdEBOJuBaJG8KWinfRnuvCuVb
	cOBJP11X+mRgL97mR4KQ5j91780kXYc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVwwGpgK;
	spf=pass (imf07.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793688876;
	b=uBCNk7xhwU3s2Uyh3AGK3Iv4NyLwFefX59ePqV1bLekXOQhCDFOmdiZNOLGJzLf2vFO+dx
	D/jQo7tE28jZMLzdXniRMquRZviD7L4FEXBx6TH1Xs1vHriXyp0FDHpOCgfOrb2DddDsdV
	L0uLO0v/cw1SST9H942C3kNdb/NPh5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5ABB43E92;
	Tue,  3 Nov 2026 06:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D471F000C1;
	Tue,  3 Nov 2026 06:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688875;
	bh=pI+R0vssS3+rBEwGlEmrhAJtAWwC+K6R2fL7Q2wxluc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HVwwGpgKph2PTCR3kNBpzgeJl9Fiv96ILTSVlqr7otzEN5KOe+3Oq36TZyy3FWiTn
	 B5JC9rU3ADl82tq64bDRGFlV2NLyjhAO9fPnLejhbwzeG1Z9dc6ee0GVq9fDWJMr9G
	 uEn9b1MhNhFVniqfmxfA0bqOs/QBhcC6kPjZ8hJFtdA34IHlyTNGGcCj68Y62ICtjk
	 Ouq+kpEpWGx9PHR9MkFKZswgqiZXimSJHDR7+eldSuTYGotHgFLXgZCx0dKYEpIAcw
	 6pYXyTE/pVVs21IvMkWqyQ4k+6ZNZ7Rqbrs3FA5NB7/Klj97W0Huza14rR1CDkHC3E
	 tLDaFtIRr3wRA==
Message-ID: <a0736b1b-707e-4f24-8249-c7363c673a43@kernel.org>
Date: Tue, 3 Nov 2026 07:54:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 19/23] tty: sysrq: let procfs copy in writes to
 /proc/sysrq-trigger
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
 Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>,
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org,
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org,
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org,
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org,
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>,
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-19-a994bd4d3b1a@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261102-work-procfs-drivers-v1-19-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xgz9naitojsi1z7kp7ueo1dwwnkq8f3n
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7EE2C40005
X-HE-Tag: 1793688876-603559
X-HE-Meta: U2FsdGVkX19bxv+AFda6t43oc7u7LuruzX6yj/AdsvcuIwyD0jjO1b9I7OX17EdRw1fmr5xJzeJbWjSKKLWZYDlenVzM2uqlXd6AO3BeQve13NCb7oC+sCRYHcEUOyBQk6CGK5UOKe3GP9j4idSvykoLkh7uZbVI8g7f9c8hly6G+a6Fc0l4+X9ixhM6v2tU5DuhFDd/kby+ZkANnUzhnS8EGstNpRWmaz0o2ms+QxxvGyVwkUA23NvCscqVSuUjJrNX6L5aJe/QXQrfCOQNoVLHl6MupJjZqtGMR+gy/EzRS7pjwJOqrFpYRkIn+cxJLT8CurEToS/PZF2Ow/18owPXPvbBRSt+7AFJ1mF/qsgfIvw8MXvMLqdK81D2XLmK84x54RVGpEzFp+HZCvxN8c7LpXloONS1068PSXX0jSkp/ob1/2Ksv92ZKR7MbaAzoo1Q4xNBV0ajsM/jNa7S98Us0kd3wJwyJHjcBbkt4v8ctwSoZ1lVc9NyaSE3JQTXib2O3LSMN7JRaXQJNfTrR2MuA171f44MjQoh8ouKoKuBjzV+0weE6pAJthl8jA3JP7pHKCfMBWmMY7JrgaBfiIbM6QNa+TlJTjtibqD2k6+9SwSZneNzX1YQQfydfSR9yd0+6TJJNFKDFsRvvS9Foq3Z2J/Yocb9HBcLMTGPA2KZ6QNdr3+IBgi1dtZ5m5QLVFNyZxc8sOUYmuj95yLO7z/gmbQeIERC7b33R9y1uNrlIv610pU00hGqjJiqEoR7zNkVTTf3c08fx/ULCoGXD2DJ3dsMb87X6MY8ac6KLORNDgQ927CqfuJn1+Zvg1Qebp+8XsqRvpMEm2FWTczIOqyjtEOsKaI5fD5QkQw2di6OAp0E0744zqGUkQpl7ucniC6AoO/QuWwagNgS+xfDP/uqVMsUCKush/sK9kiXS6bUfBRySg3YgWc3R0gCFY+kyVdqwIqnos7m6+MVbni
 sxgjZX4W
 7hWsvt08Gr/9MLDqSQX7xy0kYOqV02mezp5r1eif3s4VtfgSQF7M3ZERWZJFo1qssslJe6u4Io3W7n9so41UdJ0oxYEkL45vj4xBe+PlyxBR7zr7VGrycBIXpKEgJwskzqJ1QBoejOKajOwLfVifeQ5qg9P0d51A+sCX7G6ID8NlrX9YzgnqSp8/Frh3okxwDIzZgfl2bhqoCT46/TfGZaoPn3iQOP31SL2LVI5XAbW9/w3Rf8dpNqwV60kw/h886Ygbmplz1A43tSitwfc56LQzt1Kn/NkAlAfgt5IC7XRKWGlUgIlY8uoLGlonHOKl6n130
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 02. 11. 26, 16:07, Christian Brauner wrote:
> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and handle the keys from that copy. Writes larger
> than PAGE_SIZE - 1 bytes fail with -EINVAL now. They used to trigger the
> first key, or all of them in bulk mode. procfs allocates the copy, which
> is as small as the write, opening the file allocated as much already.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>

> ---
>   drivers/tty/sysrq.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index f4571d05b496..99363e1b59ed 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -1200,17 +1200,14 @@ EXPORT_SYMBOL(unregister_sysrq_key);
>    * However, if the first character is an underscore,
>    * all characters are processed.
>    */
> -static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
> +static ssize_t write_sysrq_trigger(struct file *file, char *buf,
>   				   size_t count, loff_t *ppos)
>   {
>   	bool bulk = false;
>   	size_t i;
>   
>   	for (i = 0; i < count; i++) {
> -		char c;
> -
> -		if (get_user(c, buf + i))
> -			return -EFAULT;
> +		char c = buf[i];
>   
>   		if (c == '_')
>   			bulk = true;
> @@ -1225,7 +1222,7 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
>   }
>   
>   static const struct proc_ops sysrq_trigger_proc_ops = {
> -	.proc_write	= write_sysrq_trigger,
> +	.proc_write_buf	= write_sysrq_trigger,
>   	.proc_lseek	= noop_llseek,
>   };
>   
> 


-- 
js
suse labs

