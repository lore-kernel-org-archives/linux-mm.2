Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FC6606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JAvgdXbW
Received: by kanga.kvack.org (Postfix)
	id 403CC6B05B1; Sun, 22 Nov 2026 16:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4946B05B2; Sun, 22 Nov 2026 16:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3FF6B05B3; Sun, 22 Nov 2026 16:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E97626B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:19:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59F1E805B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:19:52 +0000 (UTC)
X-FDA: 85464022224.20.1515DAD
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77EAE140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:19:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JAvgdXbW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795382390;
	b=ZuHtzNw5WvRWcBBp0wbAv58/or+2ratDfvm8+WmRfpt09qo/YWusfRN9AiS4eOm9eH2WC0
	bLJeYk+NvOm/F3EzKNh+FReNGUFdymYZggq7sf1t5/K6evkkJvmRkpiGDEnngama5lJweT
	ipFsrFszQC5UObZNK64444qYdCHS+5k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795382390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlHx3q8hlvOapQpFRbpBP1dZTmv+VTbbRyW9rgzkxFM=;
	b=SPVzq3MK7TcUx4X7pEjICDvfiQfHI7NLwE8tq0Z/tj+rIK5VWvtUJvRPeJv8AVbubXN6R2
	7K0hrDtq42ObZdvo/hwApSDWXcvX3PjDgMzOLUJf3XXhhJqOM3GES44et99y5Cy8uuz/qJ
	w/7CBvT0gOdcVXBD7Y/YCDVLU2cnSjw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JAvgdXbW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f048bc09d7so61355ad.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795382389; x=1795987189; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jlHx3q8hlvOapQpFRbpBP1dZTmv+VTbbRyW9rgzkxFM=;
        b=JAvgdXbWMBaITtYZ7SxLeX83AezBPTd/HHed1Ucy7VfEkoMX0tMVnrz5BBaQJK+oJQ
         wuNzXdv3+P7YkBLPbawBd7ZGI3UaoU0DNI54vGT2wHzZoVO0MJbdTyRv9Zr43CxeRgn1
         rxxep6YC7wg3vgrBV43Zfca7aLWUh4ukSQh6GzWKsE0hzNwd1QQtCwVwBjAqVJe5p4wC
         PAnLchTfZa6M9CPd9XfkBhtDAckTapZMETD/aOxbueHN/K7x8na2dcScB8eGeY9xQz33
         69As6fSD+DDGfwfbLkXRyh0ctKYEmdz3dM2waVfniFyq4Rms39Lb7VaX8M0hr2II2dg8
         Ouuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795382389; x=1795987189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jlHx3q8hlvOapQpFRbpBP1dZTmv+VTbbRyW9rgzkxFM=;
        b=OJv5QTHzQU0bhJj+vtjbVxZD5RfFafctpz1ZPYuGH0impUJkgpZDuBivqCw6Q0zKc5
         qQh3nmIldbtcXd3FIwt+sh9QXutbBgv7KAsUokqdVzfVwjDtGcYDADy1VKBTxGfRibOz
         Yd+42WIMLt3M/P+KZgRTFHO48PTLB8sNhZEGnCyVC9+W72msfNcNK47jVhsWsdr9oNh+
         e8WOG88Mfk2zDBstXOV4wwOfrrfIbfa+BUcqAUcRGyGNYP1qro5is1o6UOKqLOe3nqaJ
         EddikB2DkpDGFLsP20dU/rQb8oGzdButr1Z1bZ2QTzu8wCx0TzucIoYI67/P6hRw2g/D
         ByYw==
X-Forwarded-Encrypted: i=1; AL+hErFjIVUvgnSBBnXIrSxH6jy0N7Rf7YuNJ4+r/QlfZht9FEeo05z3kx4Vsz2lyBKo+jLFEAHR4G6drA==@kvack.org
X-Gm-Message-State: APuU4Z/tYhQShOWFIxjWQo7cnrZNu0/jyxmyVq7JcqJ9ZCTsuwtYs5cH
	9HmWW891Hai6yHp8TebGuIF66+aOau2C5Wif5Ye7BRbE8hF7LBHjGJ8gqyf80F+LEg==
X-Gm-Gg: AZFdTZf97JrTuPEIfw7D0bQfM3rYCA8Kck5jg12+/7rtPZUhUMW7akvCVRoQ1fgFGJQ
	r9DGoG0LNwCz4aB3jUV4p7iesTgVJZxFoN1canPu419/FeQchLMwv+YkgMoV+pMD97KeX1v6e5z
	sZ8wsWEtl7kLYzFvPYg4i2CJWNVr5mtqjoY5vdcRAqu3XuN2gHBQheDed49P7XQTvaV29gu6/8P
	NWhl9Tf5Bc3v1LUBIt+wqxWS21tNQVR4CnztjMIwBBxsXFyb+Dj7zXI9OHSmuQjLEfJhT7D7Ea6
	COIrZQKr1Muyxn8958VrKqKZ2FHQC+42M4bxRt+jNQWnZBajOSl5gtaaJU+s45CgOQ+cKmnOT0k
	BShX6loaz/kh2YE/WhzICER39BRPHF76GULcc8xUiZC4xNuoYu8JGZ/IjXewbJiGRs+vmATqdzw
	KkucdOiNbQJPZAOqvm28aVXp9VrQhIRQcyIYvwX0UXKtwveYS68JQ5Wm7aDqGgJn8agAH5koCe6
	CGzpQqn+OXssXdJwe431NVhOipuKNkEZnsgsy0NjvZ36YHjRcS6/DTp1Fmcs8VxzTmfhlEzsIEf
	ALGZAM1LFW3C99mbS5DuwRlX2rIlz/uFgqzHBpQgEYCoSSioW+35ROSJKcEvVXakpIvjmis/a0S
	CLIiindldGGXo3dCMzNan+A==
X-Received: by 2002:a17:903:19e3:b0:2d5:db38:8010 with SMTP id d9443c01a7336-2f066708a17mr4257845ad.15.1795382388397;
        Sun, 22 Nov 2026 13:19:48 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d63728sm18461423a91.8.2026.11.22.13.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 13:19:47 -0800 (PST)
Date: Sun, 22 Nov 2026 21:19:42 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 03/27] liveupdate: Export symbols needed by modules
Message-ID: <awNVk3q6Q6sAHn6U@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-4-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-4-vipinsh@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77EAE140007
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: k4qc6pgnx7tu38dh6xd8kchdp1co9cp3
X-Rspam-User:
X-HE-Tag: 1795382390-578819
X-HE-Meta: U2FsdGVkX18rStJwSHU2X4vbDRLyVwyRqpzqbrV54n2OgRD8gxwO6D9BrXe44lR6AmmIvJKsnNv8pBzToyTNBeFD/SlCR6UbsRC9KnR5nPOfPW361OEqY/alxfhDURVrhfzBbEaeinb0lHie4i473MOQBcWqQ5CwISAZxWQPOrFVTVdL3PZJq57UyjnyqogJdKv2Qh5aPhOm/lKW+xYJbF8wUIHDb+11OnIa3yEcdstvnif1QPjtYx8uHFaCBJ2rip1R8dUZrKUFUGOmTkPeYJZo7BDaB2bKWpuV4zh/z9mpGZ/ydrMp/F9X7Kt6pHZ7TY2wOyei7ZiI/WcETNKCLGvdmXiVOMYCHxHAY4IImVYjhuh7LdLyUS/+q3ONdQrTVPy2Ut2eKD/unlQPPnB+ZMe+4KPA4R/9RPxmrrTF7JcSHtkRnk01R2YU9Ql/ZFNwBdu5+9TEh7LZB11Ugs3PdwpCtX4bvzHkWN5mObwQdJaK6DztJTfy6FNkUpKmDdDPCsyjfvxd1NVassBMVLgTapjjkO83G0waKB5MeFGJBuwHO+OIVj1AIpyn/jyYYgETqMq6Dk11PW5MdGf5en8BMaCNj8oChD1RrVrXLGQvQmXOBkGVPSTT6odqWubFYUM4Bp3qfRWdz8C6pJx8kyro6deQYI8UpSNdppoluIyz18P4vG/Nd+OGsG31OqbqzfSI3ydSTDHZjsZn3Zd2XVm5vMxcKw0JfThoXsyprmaRCqDSLUgdvr33bMCbdgl2tMLWD5ka5LS1vEttTlX24zFSGWeNy5z70RvT9gJUoQ5xkeUKzIDlVUvYo9A+rS82oZeK+8dfNQHsby0ZDKghvSVLgD5V0j/ZtFI5KOFJsz1+yuWumtKhWQIRvotgAVq8LuIEd3CEBrSt0WMeLmBqa+2AebsM8ADxkHZfZS4mu1lIQvv2GusRR3o4a1ND0BcFtbALn+e9rlRe5v0zmER+GY7
 nwm+l58k
 FcLL0bJDE6vK2Un0XI9q3YIuJ9YoNfDc06LLA20zbjmGqIwwukFZ/fYvD201AjuG7QfRjjFaPDiXTfeMgpvEC8alTtYgJHnjBss8UUUTCARuQKwt6VjjDO/rhyvmrbY55jgf3fSAnbhZDUzrjr1NAY6SZ0RZMNNYNy/ibIqZpQMiwKUfr0n+uEs0Ma8lr4KF5QRC5LXRJ4qMFWst6O4xgnYktm8C+XGdB6C/cVcfwk3xcfjX3nwwvPYqH9ihVHuHdEy4pnyxVdIXf2m5+raHb1mppBjl3HY3kwOTc046QZuGO5AFkVwwEcZOA/5eUs6u4UqslCzIb7ZR5Z09rshLL1wPRGMVKtFgP8LR9PKqBCu6ACKTIN5s4ebiBAFGphKkbquz/Ptgcb97Az+BND7q+EeheP0r3cmqB1T6KoxAIeb7NqxUIWLmPRHhk2lTOpRm+X1Qi8u34ttAtNdp3A0kuWs+2ge1r3clxFtE2bfLndY+FbisXmZXJKjAiMTYp3icvjVIj1l6/2C8xKuLccR+y0jCrm8lnl2cXe/S9kQsK7VtrFikzksINtg+h4KUHt9g4oqWBYsxk8cZ/q8xJ91nu/BtcY9FdOuDbn796u6RjIYH5CPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 07:36:32AM -0800, Vipin Sharma wrote:
>Export liveupdate_register_file_handler() and
>liveupdate_unregister_file_handler(). All of these will be used by
>vfio-pci in a subsequent commit, which can be built as a module.
>
>Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>---
> kernel/liveupdate/luo_file.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index dbae0715220b..6aaa9a531428 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -916,6 +916,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 	up_write(&luo_register_rwlock);
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
>
> /**
>  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
>@@ -933,6 +934,7 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
> 	luo_flb_unregister_all(fh);
> 	list_del(&ACCESS_PRIVATE(fh, list));
> }
>+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
>
> /**
>  * liveupdate_get_token_outgoing - Get the token for a preserved file.
>-- 
>2.56.0.317.g454f8302e1-goog
>

Can you please send this separately, it can probably go in without rest
of the vfio changes? This is required by iommufd and guest_memfd also I
think.

Thanks,
Sami

