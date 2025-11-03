Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56ECCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF918E0028; Mon,  3 Nov 2025 02:43:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FFA8E0015; Mon,  3 Nov 2025 02:43:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6998E0028; Mon,  3 Nov 2025 02:43:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECEC58E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:43:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7C7689522
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:43:32 +0000 (UTC)
X-FDA: 84068505864.05.74B637C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 905011C000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:43:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oHXNX1Pa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="pHLY+Hy/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oHXNX1Pa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="pHLY+Hy/";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762155810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1+B9zt2AEIIJkaGtGDVUCOE0R3A1Xscg4L+TVTph6g=;
	b=27FWKNfFumMlJzC5zQfs02icxjC8sZjFORyibxLOBm7lUk50UDTp/eJg5n4N4W+u/xk0KV
	WdtTIaHwWmHC8HcfZebxBOv2QOfsRgMSlrR+bP/24S0IgRUpY0W8hYxsb1ohmLNkrjGUEO
	vpmv/WZ4fypGKkg1s1p1A36WrL4s1W4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762155810; a=rsa-sha256;
	cv=none;
	b=YfDoNFpxChtsD1iOyDhB4Ic5jJClq6Buq1GWbkzHFqoaxGj/IxMY1kcQd3SCDQnLoyyusf
	57Ziw3qR54HxjLtOEi5SsE9W1mr+z48ztCak5yLrF8pxz0RXyJtqiQfze0wrolM4SjWRIJ
	hjQwDP4e5kUU1sz6H/k9p1Z/jY+3sqk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oHXNX1Pa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="pHLY+Hy/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oHXNX1Pa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="pHLY+Hy/";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4614521D9C;
	Mon,  3 Nov 2025 07:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1+B9zt2AEIIJkaGtGDVUCOE0R3A1Xscg4L+TVTph6g=;
	b=oHXNX1PazznzOv0TdsXLeV+LALADhxuXwcl6Pm+0iogwUrpycWJY2psgvRUOkUYIw+4bQi
	E1QgV5Ti42OEP1ubrzQSTkseczV7hrSyj+26FA64EZUtTl5DrK1UHVvOY+dZ0DsJDh8akK
	qxzC9dr10socnAM0T/eRTQ+/HWKZg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1+B9zt2AEIIJkaGtGDVUCOE0R3A1Xscg4L+TVTph6g=;
	b=pHLY+Hy/4YS85jrJAA0r7KCCBCWUAEHh1Wyp9LD+wkgdqHNSTY/RTBmx4yG+nRWxbOgD+0
	Buizniao6Vt33TBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1+B9zt2AEIIJkaGtGDVUCOE0R3A1Xscg4L+TVTph6g=;
	b=oHXNX1PazznzOv0TdsXLeV+LALADhxuXwcl6Pm+0iogwUrpycWJY2psgvRUOkUYIw+4bQi
	E1QgV5Ti42OEP1ubrzQSTkseczV7hrSyj+26FA64EZUtTl5DrK1UHVvOY+dZ0DsJDh8akK
	qxzC9dr10socnAM0T/eRTQ+/HWKZg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i1+B9zt2AEIIJkaGtGDVUCOE0R3A1Xscg4L+TVTph6g=;
	b=pHLY+Hy/4YS85jrJAA0r7KCCBCWUAEHh1Wyp9LD+wkgdqHNSTY/RTBmx4yG+nRWxbOgD+0
	Buizniao6Vt33TBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 346C91364F;
	Mon,  3 Nov 2025 07:43:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TT3MDCFdCGnNQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 07:43:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9AE38A2A61; Mon,  3 Nov 2025 08:43:28 +0100 (CET)
Date: Mon, 3 Nov 2025 08:43:28 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 03/25] ext4: remove PAGE_SIZE checks for rec_len
 conversion
Message-ID: <n7vgicrsj4soriob45vd2pwqtm77jt6wnsk3ie5g66am2oqvji@k2ayujwhxcrx>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-4-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-4-libaokun@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 905011C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: rnijz5r19ni8et581jskzd457zum5sw4
X-HE-Tag: 1762155810-415992
X-HE-Meta: U2FsdGVkX18H2jx72PVndoivIMD1FcWCdubMxN1nDhVxyvymMRV7BfNnTHZZVfp3nArn7A6EovnH3O5tqIj21zqyAoNnAJeT208XfpntbnipqD8eexiOlqvkolsVVGZ/dJFRx/y0gsvAlxQp+wwfppiJRNmDnuEkrrO7P5mv0f7tA8Q6PQCFYg3CWhEIH8YiIZBX/xYcOF2d+i8NFaNkh5/mBaFfmi0Hm2eVPHU4jxalnia04TreTbNHRQbwBYBCi/ZIRYAw2f1etDiBhFRSRDD8eEwaDBM1hlP75U9EmVxjEZCVVeMnYBjVnFzb9xPn/YJwbNuMlnjsmXGvjzfXf/Hy2gd1VqzUEhmMw8OoTSs1xxf39WZsXOv0a/SIjgyJlhMPMKKbYNwNG/HSdItCXReTiIWwm8AhBLlL3LnqWJSZp3EVRsWLn6s8K2UEFBmCjEsyJ2ZhZOPnonZfHojWEVhYp5Vjcc+RJ8/NJeKiSgjW42CV2WySXBuiuGBIhBDAPtecbtNPQ72WKjSDt2f/BqTk0GwBUwpSOTG9YJqz4raC5pkXpVE19+cW4h1F0q2y0W3LMsKihX8Uc2ZQKbwHnoIAylklW8PUj9q556k/RbAbg7MtbouEI3LMbc8z6saOu3WyszNuJrq12rhyxWsjwdtL0N8FOFoiY7lfG3tpb5hjzFQLY8Y7L1vPPc4GJR2SbmEiaXVAU+IxNJmya2C8DY/3RuhLNs+21z4ejEy0wwk9OENc8cPl89RPVYbdmQAJPXJdq4PBtQgIzj7BlD4ELnLdhzxDnnO6fNz7F62OySMId50cQI2nShPkR+LcSQWpCMVN+7acV2rj//w+Hl5UVeXeBpX352OY50bMYVav/hFGx6L4FoGb0j9J5dYUHSR7mBUa9uS5OW+yJ7P44pr9oNTb1pupgE2O4k0T3X9udusX3HtXDL4jnJDR41E0KQOSu9INBI8Nqt9UJRM/W5l
 VPlWSDIn
 9llrPjDqB196T4H4vFngcO0h4t9BFaMlF3D2NmO4FXqyNotT1HwVKxh2DhAgpC39gE7W5V0l6LsXvXacJKPgxOktcs2CvvtZcEWNcJTC/NiPvPKvqSEG0sW9j3FIwDe9J/FRWLrijbX5MzmibdZmQHEhQBBkc9ctniDsuQhV73ujvxXL/jXl3ds/fG+ua7gPFs2BQftogIHK8L66LYhGqWTJYlAdSaWleQc5JvCgbsdxgS5VrZSCErSxPlBSSyWKIAb+8SV8i5IbBmUDHPYQD173CepoW6P+kh/A5O4o1pRrkBNMzhBcDqxE86dy4Vl4ezAwygrKZmjaYzDbvnOngpUwABL60HboF5cvSUXyw2tmlTVMb2cZica+6V41+8KemmE27tbZPPJj1+vv0JAyq/vJa3PfGkMJieETsFCe2KE6rmjDgnAGdQDqH6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:21:59, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Previously, ext4_rec_len_(to|from)_disk only performed complex rec_len
> conversions when PAGE_SIZE >= 65536 to reduce complexity.
> 
> However, we are soon to support file system block sizes greater than
> page size, which makes these conditional checks unnecessary. Thus, these
> checks are now removed.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 24c414605b08..93c2bf4d125a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2464,28 +2464,19 @@ static inline unsigned int ext4_dir_rec_len(__u8 name_len,
>  	return (rec_len & ~EXT4_DIR_ROUND);
>  }
>  
> -/*
> - * If we ever get support for fs block sizes > page_size, we'll need
> - * to remove the #if statements in the next two functions...
> - */
>  static inline unsigned int
>  ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
>  {
>  	unsigned len = le16_to_cpu(dlen);
>  
> -#if (PAGE_SIZE >= 65536)
>  	if (len == EXT4_MAX_REC_LEN || len == 0)
>  		return blocksize;
>  	return (len & 65532) | ((len & 3) << 16);
> -#else
> -	return len;
> -#endif
>  }
>  
>  static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
>  {
>  	BUG_ON((len > blocksize) || (blocksize > (1 << 18)) || (len & 3));
> -#if (PAGE_SIZE >= 65536)
>  	if (len < 65536)
>  		return cpu_to_le16(len);
>  	if (len == blocksize) {
> @@ -2495,9 +2486,6 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
>  			return cpu_to_le16(0);
>  	}
>  	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
> -#else
> -	return cpu_to_le16(len);
> -#endif
>  }
>  
>  /*
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

