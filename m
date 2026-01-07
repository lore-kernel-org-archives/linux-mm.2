Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFFDCD5829
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A140C6B009B; Wed,  7 Jan 2026 05:07:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE696B009D; Wed,  7 Jan 2026 05:07:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7C56B00A0; Wed,  7 Jan 2026 05:07:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7D56B009B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:07:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 271A5139A25
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:07:01 +0000 (UTC)
X-FDA: 84304739442.17.959D5F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7321B18000A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:06:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iodDBfPB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767780419; a=rsa-sha256;
	cv=none;
	b=2m6RGltYoApR79OlrdSNnSOJd8Cbkj+XmErxKnxtxkJO/U43Wwea7sl36yXUiqEeTNgLRU
	78/H47Gd01NhJMSwCscP4DfACB07/SBdvhYgPBxcgRT87eHjf6d0R4ZPOrHCw2PjSK4yoQ
	I1jl3FOP/rqnMKit6DZ9teQXtbhXDw4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iodDBfPB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767780419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36wuYSpDK2R7J0yvGtlN9+rupa1ABZXtzEKw/I7D2mc=;
	b=2yadXXu00PRY5wCJegZv5tVLNpNU3FXzJMBMfgZIWkmQLsWp6CQKGBqd17zNanWCP8S9+n
	LQyCjaIxFJ+2u69LtORaOIvdm7sAsHn903+V5XBPW+wzYmNwty4hWUqFUuWC4hH8dQMded
	Bw8qfR2QBBc8ix9oNwVFZeIkfNhGvdQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6889F40135;
	Wed,  7 Jan 2026 10:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CEEC4CEF7;
	Wed,  7 Jan 2026 10:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767780418;
	bh=nEghX8BiAqAAWqHNMWEJ22do60eHFb1GQ4oeVhHrdpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iodDBfPBhdLwX8pOjdmGnJnUxVl7xS08q5+D8BsMOb6lm3GcJCWmkuDCE65gWHFqd
	 32pHmYlEab+je+ZkjWMrwlN2GEIzZwffcH0HZh0b64+ieCEGFnRIm/NclkKM+Oipf3
	 3aLbPB6lk7ZxAG1MbpSTwvtNyWwbtQz79LOLGwZJPyT3tJX/3Beu26Uwh6w0WOmFi7
	 Y2NHFcsIc/cS0XKLxn2VHzWwL7CjFJZa1OW4329qfOvkC2z2X6soTjKMdZmsodfugG
	 ZdL5NiaV5Z0lycBNtBNIr/HTqLeuOiq38c9NH7bvoL1yUe3lKYwRPOt/dU6G2UNfQr
	 yAUr2Vn731tLg==
Date: Wed, 7 Jan 2026 12:06:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: l00580197 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	hewenliang4@huawei.com
Subject: Re: [PATCH] kho: test: clean up residual memory upon test_kho module
 unload
Message-ID: <aV4wO1ORACvVpgAN@kernel.org>
References: <20260107022427.4114424-1-longwei27@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107022427.4114424-1-longwei27@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7321B18000A
X-Rspamd-Server: rspam10
X-Stat-Signature: r5w9ezmwa51zntna3bde3fup7wgs7agk
X-HE-Tag: 1767780419-631972
X-HE-Meta: U2FsdGVkX1+UKyTFJ1VC1RW6X978WXIUu2X9ZgnZLct7k1JOvcOnz+Uo4SmuvdzUMF01jVI5/hwbXL3uxYcQRiRBvJKGWL58YPHmqiwy/dwU6abJSnGZ+zvR6QblfO/xYwJe5/XaEyJvnHQCPB3EmU6uQC9RAX/hiK5REnnU9IVz5XiNRcX9+R40CDaYfW1tixPb0WVh4k1KWtWaPNtqnwxscizQOHlOtBYrbG/BXEDMg/gQrWbEBLSoeAQSi8zD5e37N829nokb8KvHYkgAZGhOiaQAuoUKg5OJbCwSrtqq+jUNuareO+q1fX9wb1cZ6rp9hniOSEa+VxX1guA68G3rCpuuohhFsf4GT+PgZr+laWBBjZKIZR1lfeU8eFeQUMGFlT6X7jT6MdApdW8dG6F/KDcfTxJwO3FRJgxlCrxbgdxQd+AQ3DcrhS+P5ru4Nv8j2LE6wn48tpPubXDD+G4pSz3myFIkN4poKYQBbbYAQTRZuZ9qzoNZWbsrIACnbt91Gvthf+oO1mmkoCSOEPfVoehqSoIB1izyYrezG4gFmAP1GMRNi26nOn6pForh28KgI2Gw0ug65AZ/5kqoS+3vvu1JikKRtIUZgyyCKbSVPdLx2MrlWISQHkmOmcxMeHZaTCQe6GbBaG8zLE4CYf44iyHyrNON+yeU9k7yiYnxOxWztrwQrlaWUcNpRgUFWv88QMIwcphwgLAsmgbqoRl/4mbET73zD2Ka7YVlh6KxH4Go2eQSJ96aFWkazd9QkVbUPy7LdTCm8W8ry/kwCQ+6FjDWQ6CaLzap1omLQ+Rs7v0hwsJUOS7lbKv/ZJNDuRCYai7SI8xhCcLYMc1KeIbPDoh8oy7D9rTYOylxcjzWYKs+Prp5+p3R/L5tVmZCoG4muoW16RMnXKaiyOY4xqWjiG5LgfTF2yOOxljgV93wmZDe9C8Ago3CR3GomICp2IFZjCbn70UuBW/EIvb
 tNE7IgtW
 ha178rXBhisi85vbRgJfF0mJYxurEWnoeNeM5jMCHn6YSEzlmv53OOT/kn7qKCjvbSkP6c6TXWlg8uUZY6CQtWykDgEvgJeL+iSGYNVsxyKrHqyy2DBMbupTd6d2NqxBNSk5hYgesphlhw7/gnq3oyqrUneacOHrptf2DScj9c3MYOwjj8pdRfZJp+wxZ5dTds9vG2E3Wq5AEJe5WIGcpGrYIjokLpZsazpjRRAz9JXlJY9YFy816WUIDwV9HQk+u21vm7iO9kTgfNBnD6WwB9SmZw4BqgVnY16QDuE4PM0GIjH2AhnOVs10p9tcf7VrymzCpKZQeqpiICDaC8biX4mN/a3Q00BXMQk12
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:24:27AM +0800, l00580197 wrote:
> From: Long Wei <longwei27@huawei.com>
> 
> During the initialization phase, the test_kho module invokes the
> kho_preserve_folio function, which internally configures bitmaps
> within kho_mem_track and establishes chunk linked lists in KHO.
> Upon unloading the test_kho module, it is necessary to clean up
> these states.
> 
> Signed-off-by: Long Wei <longwei27@huawei.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  lib/test_kho.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index 47de56280795..69230da5a056 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -339,11 +339,15 @@ module_init(kho_test_init);
>  
>  static void kho_test_cleanup(void)
>  {
> +	/* unpreserve and free the data stored in folios */
> +	kho_test_unpreserve_data(&kho_test_state);
>  	for (int i = 0; i < kho_test_state.nr_folios; i++)
>  		folio_put(kho_test_state.folios[i]);
>  
>  	kvfree(kho_test_state.folios);
> -	vfree(kho_test_state.folios_info);
> +
> +	/* Unpreserve and release the FDT folio */
> +	kho_unpreserve_folio(kho_test_state.fdt);
>  	folio_put(kho_test_state.fdt);
>  }
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

