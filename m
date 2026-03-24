Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4620AF54ADA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 17:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7129A6B0005; Tue, 24 Mar 2026 13:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BE36B0089; Tue, 24 Mar 2026 13:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5635E6B008A; Tue, 24 Mar 2026 13:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 420A06B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:06:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E309FC18D1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:06:03 +0000 (UTC)
X-FDA: 84581584206.25.2B733BF
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F8F110000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:06:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/ileo/l";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774371962; a=rsa-sha256;
	cv=none;
	b=Wrc9uvLoCzVPGZ7/AkuzKKd+KNNIMf66I2cYWUuPvd6/YvnF+uvfYUmgkXrXWex2WTF0u3
	PU33w/XvQbunNVhZg6JOOU/IHCpAu1O517Rb7aJtFKxZeaXJRaGfdyEoPCX6duyjtj/Mec
	4P5OlZxmEVozTyjeFzAxTit9uxF/txY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/ileo/l";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774371962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHY3J33g6ujwnRTqJrGO/jD1PTpcRqvXhZiCbNP/dps=;
	b=5cdyKC6EIeTy8eFPoys5OFRwNmIuBu/U8YAAMmmpq2GI0K+bZgnNnLRnz4ET5QVCg6/SD8
	DFthIjbHJ5BtU41AtzT8mZn+9SLHnb7oPgXLUQ1ckJpe7bWbKNHdslnnphvKMl+lHQgGcE
	7638oT2xNukDBRP5HDhLRo3F+4lVj6M=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35c05d7e0e9so774244a91.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774371961; x=1774976761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oHY3J33g6ujwnRTqJrGO/jD1PTpcRqvXhZiCbNP/dps=;
        b=T/ileo/lw2pd0zHCZmjzzWT0/Cw+BAWk94DFOjvKJy7LoDM8dGnd42sSpQn4kijiT3
         fv/WHpPBZwmRWTeLGdw2qeF2wwzII3vy06344wwIZl79xMikHUKE8gvy9/iKhity+kGj
         EskhovXs1KMTAI+knSBXh+VNyaoImwpNUWA+c3gAjRzgg+R5LfseHkmlDBwZWd9rsYC4
         np40BdgbzyDozme7Z49VUuHRRKGJolHcXc7wVa7qq915/Rtl7OjtpYSBS2ahzCCtB5J8
         55qfg4g1h/4sseAjP3kl2ISGLVKhahdeBPsQ71xzjSCvgAIg5e5QrGjAuk6v7KdxmVGZ
         6miA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774371961; x=1774976761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oHY3J33g6ujwnRTqJrGO/jD1PTpcRqvXhZiCbNP/dps=;
        b=UIwAzJ/1AoIvvuGAF7y6D1UYw+WibPH01BD5YXpQZHtZsQKRbmLkBtSK8Lj2o5VIi0
         kFgTHCSpq42uDJVFpjQpZkNFFu0aBV+7VgJpzCqTG+4XgSYiVVQqEu1Mm8V9l0nZGlOa
         Fy8JgLPLlUbIwC0noVFUAwlnsjP+miDHETTjZ5VOK/g9kkyMnEfUdxpuBEOzhFhda/zp
         iB3FfMAuTTP3j6SsOD4NM2xqN1qXzqa94S2YdRaqTiRdThMRy/PtwSnYtuF7+5BeiI1s
         8N2onUzXTnIc6Lr/A52t/0d+/qNMDLy9GgUxaa1O3+eHjsxZzmqKYqZur/rervCkNkva
         CGdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDJCW50TPWDD9NGDXiianRkkNYi7u4n9fl/oEeicNW0mPb3RDYzm/bHPsywpI46qUCbCgcB8jfnQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5ycxmwlITcwqiErOY+8rNbgLp1uyaYHmN/KAo9GhNJ0EuLdWo
	1h+3pmxnahoo9AMXnATmnaLtOMZD1ReVhmTzAHF4jLsRCaSuyu9o9wVrmDH5SzewWA==
X-Gm-Gg: ATEYQzxL57ytb08MK+R5XFj/Yrg9TR9dVXZfyflsuHOYdww6RaFxFNooj08OzqiaSKb
	4oELJ7dLg8vVilpO0FKo7Yy9uQOkYd35D05wCMCk9/XAtjptUFSgaOOT55ypjQE+rrsSRK8yZ44
	z4478GkQMZyRGI0bDMYg+6QVDyQ2OOEh1km7mGIOj4AgbeQEI03IEDeMdi4QDEqoRtp4tUFrGC8
	nLghptR4pUfe8XAl8MqxelJhUZxtk+GJ8MFNLsHmdn1rw14wU/DC156JpFlfCOvVeSBWMLy3d8E
	HISf3N6GGjeE3OZNWE5iD1v7IbdPFkQVr0ijJ1DWgrvBNqeCgIzIneLR7FtGC37NxTd665rlHaI
	7BSrusRINmjXaj85/H2JA8QzBU/0hnjMUiiI+bTnp06nJ+rr2PM9oVPciM3sz7KICrPl3ppxjdr
	5oOEPgsRcOAMqJzO4k1A1lBPP8KikNduuUtkPYC2gjZOPP4g9h3lxqvuGAGe6qLw==
X-Received: by 2002:a17:90b:2249:b0:35b:a53a:7d0b with SMTP id 98e67ed59e1d1-35c0dd3ae00mr92968a91.20.1774371960194;
        Tue, 24 Mar 2026 10:06:00 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03172a8asm3524836a91.15.2026.03.24.10.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 10:05:59 -0700 (PDT)
Date: Tue, 24 Mar 2026 17:05:55 +0000
From: David Matlack <dmatlack@google.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 08/24] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <acLEczJW3sGpeL5b@google.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-9-dmatlack@google.com>
 <815947ee-2603-47f0-9b03-f523601eae86@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815947ee-2603-47f0-9b03-f523601eae86@intel.com>
X-Rspamd-Queue-Id: 2F8F110000B
X-Stat-Signature: f98azg7wt3r7ezpefzmuqejdu7ztsx9s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774371961-373023
X-HE-Meta: U2FsdGVkX1+DsfMAHTqxvNAk5gS0BEsO3fRWiGKkMg7V+fl9QRiv7o53Bzls84PFLW3Da075dlB1XLT3A09Pe7PWiJDFpvALUGZi38d3wSurdygWOKxhbryq2m96g6lUKWVIuTHR3uyx14LaydKiFDWkehaZfJa+Mr2C9qBq31R8tv5SgYEWa+ZS0RxUqai6CPs9G5W5w+x0WIV/MqhSK7DiF6E4ymtjtFRY95g8Vl8+qgB5IvnHB6pQEHaBMaH/dHXAt7rsd0SIORsi/p+yciXncS/Ww8knfb8JRzojm+qQOBmDPfU0HSpYrI1x+91fEea0YjZo8VU/PsQJqHqKIaCXhJBzP3PsYolY97vA/A2q5VZLidAUjyIzw4OYI22XYW3BA6sRLKGnwRdKao8gkkXutvGgXOAq4TCZokBAJJz1gzu+WFZm+dzk6Or22O163aDrB4CPcugVyRORRwsZTCUppfOL1LTEmBimjl4Kxr+5VadphZZkHOrUp4rO9lw3s35+W7U7QiVcOQQw3DAemirZWm0hO7/uvpbNfkLRxXPgihHvsWp0D4y0P2+SOx22kJzl+4KjlLnHVFO4zeA6nGZq9BB3sIuyQXXb6AgI8fNhmISW9Ov6iUKoACagERJvFvZzPOLyqQe65KiOioO8P5Zs8nEG29OrxxGPABHgdhkARjZY/vZhSH0TMxdupCpa/448SGFa8fezJiBoPXV157/WNNpZdsD+GXoYfO1KOP7z0ZtLazyfPPrC/Whihsdrk0gSG1sdE5ytfOLgiUkY53fnmEHJ3Uz6cmAFgm1GMR56d5IqWiO/vjnOjmG3Gq6m8oVIJ2U1DT/MMmYRqBMN6ivlX/qwVNRgzPIRDVimhSPvf1og/6ms7gGwL6GAb1UpbF+5gBaN/wG7AGD5fC7zVa3yqAO0cau7aQNn0/3tCopLEEJpZIlC+z6SH5ZyS740YBWtGxApq3cmRCT8q3H
 gMphs3MA
 Yf07TEzBYUu3p6TP7oOkIaue9+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-24 09:08 PM, Yi Liu wrote:
> On 3/24/26 07:58, David Matlack wrote:
> > From: Vipin Sharma <vipinsh@google.com>
> > 
> > Enable userspace to retrieve preserved VFIO device files from VFIO after
> > a Live Update by implementing the retrieve() and finish() file handler
> > callbacks.
> > 
> > Use an anonymous inode when creating the file, since the retrieved
> > device file is not opened through any particular cdev inode, and the
> > cdev inode does not matter in practice.
> 
> do we have a list of struct file fields that do not matter?

My understanding is that VFIO only cares about these fields in struct
file:

 - private_data: Pointer to struct vfio_device_file
 - f_op: Pointer to vfio_device_fops
 - f_mapping: Pointer to vfio_device->inode->i_mapping

This is based on cross-referencing VFIO_GROUP_GET_DEVICE_FD (which uses
an anonymous inode) and the cdev code.

> > +err_free_device_file:
> > +	kvfree(df);
> 
> any reason to use kvfree()?

No this can be kfree(). Will fix in v4.

