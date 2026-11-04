Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76227606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=TYnm1SkC
Received: by kanga.kvack.org (Postfix)
	id 950996B05B4; Tue,  3 Nov 2026 19:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B28C6B05B5; Tue,  3 Nov 2026 19:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779D66B05B6; Tue,  3 Nov 2026 19:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4386B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:43:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 470BC805E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:57 +0000 (UTC)
X-FDA: 85395589314.12.EF59B5B
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4232840005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TYnm1SkC;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyfJTg/htaOWoI7HDaUiAyqJ6hW+/dz/pp1CnZqfneQ=;
	b=A+14DNyzKttmhqGkrYcYe3VNTEKz1jzJmivaHnzzO02tcYg7ueN4oVMKKXeiQWIfMf/RrI
	+EMv+m4JcgXy33NFYFH7XAdj8wioZ+21cdjwd8WfE/vR5iKaNTHMeU8ktT2f1dOhx+9GXu
	5SJ3JAH3ap5NRUE8qrSEPnkqkr/coWs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753035;
	b=TvFZJvD3cyX6qEcIMsawbv7roSy153FxDqDyBUl1I7010AbqCmJq0DK/EwWZgYH4nvmvhD
	XiacHtULYMkd+TNzvx0urND3u8Ch+RHcQRQhwL9GO5lPjK9MGzllgNtg/Tobd065/+Lniu
	ZFYAhLrrRs+uzZ4d8ujkdgmdrAUuLuk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TYnm1SkC;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-98301b325c4so47485241.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793753034; x=1794357834; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EyfJTg/htaOWoI7HDaUiAyqJ6hW+/dz/pp1CnZqfneQ=;
        b=TYnm1SkCu3ERxff8i6rbOEMCXIZEJidnNBVPI9gdPhVjARBSiO95eDSLw+UH8yClI+
         aNvVkRIph9EG86Um3HP4uULR+PXAS9pdrw7zYbYoM2eJyxuDMdHp4YfK8PbYfh5yOR40
         8QuBk70zibRxDwb28uK4kLvTwc0lzlrMk07qgZfwjPPNuccecFZd8ntru02HJCRmumC2
         xmOtula2QklvZvdrSuJwPviu6mpmOReiv5TJhDJQC7Xt1PDm9oxoN7Sh9VLEGkpTWx3B
         e3aFTGfmxQ65KJg7G7e0WvM9uQKK2xYINZWl9g5w2t1zhEcRE/q+aBw7rMFT90wzD+pD
         5D0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753034; x=1794357834;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EyfJTg/htaOWoI7HDaUiAyqJ6hW+/dz/pp1CnZqfneQ=;
        b=wSr0DLcqOAa/dXc8OUs3Y0Fpc2jmPhOlhAW70Fn1LRtSSygGHkVLn8sf1dkvyhpaxb
         AU/OLzsCiwjvhDVtzwh9mrI9mCzYQZoW06AcrRLjarubI11Z0JUvgbY+03WUFDFdGDlb
         H4PZbK6aXusSoyRgu/hA62ksSsfVrKGBBo7M4pJiVSc6OafIxNj2sfr0/cucBcgcJews
         5BFBhODQriM4NhG6g5t9c7VStfckutB+HNZM6dtQmdJmH7dIyvjrlIzEGxlOG5S7JrV6
         aO1G3jbkFYtOuxJ46Sn5EUzs14GpXu1uJzyYqllnkdGUwuHmequyODagDShJ1pQXGpio
         7PKA==
X-Forwarded-Encrypted: i=1; AKwUvBwwD7kkosNQZMcL6fT35FRJwJOrq0FS4i+4RnPJ+QR1l6GxqtEsr1LoiTK3+7mZP4ZhOoGV8Zxxmw==@kvack.org
X-Gm-Message-State: APuU4Z+lWfLMzOC4sE4Ag6R1jYWRX3wvI8mJg58yT0KQO0+ww41zOtD5
	qbmISxHJPn4/GRV99LzX6fJ7qfBohz7KyE3/onJHwx2T7YFpWIfwUiobsoK9YomGiWE=
X-Gm-Gg: AYBFou3tGcb1fKOI+TYYflxZm0sbOEwqVS10/oE73SfhfQ5vYzmCzMIP0z71B3ot3XW
	WRdvTHrDAUpkKmAr0oJ/eUkO9lH6BDd9mWAiD7MJHwP3jR9L1EJc6EHqDsseQOjSMgptG0eiHk2
	LJdOz1v6pgniOlkGHiGMk0o1sL6CX3XztQlhDjhDAUs+9FFwRcjqcYJBM8OabTeVc2kF3GaCWHE
	K6i42923cI9lLzrVdpxdMl6U1MalAml+suvN/8bQmgX4yLMULLbiH8PWSQ+ltXaCfFBnChqLx6L
	MjRzytIuFhh5SiMjXRXztsk/6WOfsQmGbO8iIc3+fqus5x6a66ZU+m/jdyL/KMTjAyLtyI5yTku
	ch6XRZ/KSynPDKFgsxCxALaIHBwIcfdqI0IEbXyJ/Q0aHkVMR0A8hRr3U7FNtF5BR4z7JyhNeiz
	xTxDrhjnPM5ZVlGLP6O77JUPqS2U4F9ptw+fyTMneSUqVYyQaMICzH+uVxpryAqhRazUrEbW8Sc
	Y07pr/6tZKJd98qV3QU51UEdyk03LEuzy4G8LoFS74kimnoFlSlKE1KptDOuvd9omYRk5yDkd82
	/cYKF5TC4lRp1aWH10Ux2JuIS9gr5ek7OLxGDwfnvM57FwWF0q8sG/w0aLa3JkVoJoyMyHunRAJ
	Wtk+CD5Nk01NEgI2RgsPf8wEXOCR4NG05CkSyw0DwwZtElA==
X-Received: by 2002:a05:6102:950:b0:7b3:8f0a:f76c with SMTP id ada2fe7eead31-7d072bb3726mr5566509137.13.1793753034167;
        Tue, 03 Nov 2026 16:43:54 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fef4ed3sm527432137.11.2026.11.03.16.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:43:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 08/10] mm/shmem_luo: Allow preserving tmpfs files
 that are still linked
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261103010216.3447716-9-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-9-dmatlack@google.com>
Date: Tue, 03 Nov 2026 19:43:45 -0500
Message-Id: <179375302574.727293.677909304544098007.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2473;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=1h1grQaxg7q4T9eJCUz9ZsqoACadg1b5gQXNPrb1T4s=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6n/EU+OcPsgUfVgNKKD+WCk3F+OtwPL5xys0P
 a20L7buUNWJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaup/xAAKCRC7dyhM23N6
 3sphEACiRjymhOf/11oc2wbD8SRoiRXnFKXUYIkVDNP2l3c3tTjP+YijRPjhr/brHhBpu6LOFQc
 qfP6dwNcaAcZx2LZPoXKS+0boalahbWnjrkPNCikh/U6wyunhVlh+urHjZkJwOwmQJ5pfkpLY//
 dy2NLWahrBsKcIQKycF4895PqmSLnx2ztARj+Q8Jr25/ug9GyeTlHFdXnqjMjvuoHAN7ZSVQnXp
 Mnc6QtURb7fjRoNwkBJyiC6zjGlDtqt6MKKQ/CplargM5cyEXQxT8qWPkxk2gglkSlNMfxY3gE3
 6gf0D4WejMbWxcRdueHqdZl+rdZ5nTKsXsqupCnANMS72X30/7lcpRSB/hRl1BpV/3jrhNSqcqA
 ze3csLEhuDcrp/lXRRVYLsDh6Is9PJ6tPDb9T1Knyi/VrMGkTSUC8u2tpROYgkC1/Zoe9jaLkW4
 moEhvwwEAxKDXQ148kswxGlnCaJvzyfWXjJtBEz4c6bSmfLPzjwTEnmC3Sa6qrPvyZwTgCp8snp
 iv3/fx/KILbSbVJG5LO13Pb17QNFYUEp3fo/kzhxB3xJRZ3i18F1v8T9pkbnx1v+CTMTd4+6nAe
 GZs9Ru4nEGOFHIKVBBNu+E0FUeUcaa6a3sBAtbEVawHXo2Ny69+lzr1hTwZzARstZy7A8PKfVmJ
 H2RTjBl+HEU2E5g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam06
X-Stat-Signature: rrtzuopi4t64khq83okm8h4aupupq5k1
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4232840005
X-Rspam-User: 
X-HE-Tag: 1793753035-171700
X-HE-Meta: U2FsdGVkX1+6QRRtLUepCBiACbWKtH7MV9F3NAfUOsG6tuFq3Yars1tC1VVzsTyvNXoiX75QYfvQfUnPEEHSR6vydnQEmeieTDx9kznHhz9GwdqKSLvpOuH5GmVIWafvM4Z0dLQS03IHsQUZTLzFtpwsXkETaZqsNiySyXD5dWVoUJ2xDGrf2BAcw7x0UGGbNC7ZJJxs1qz0hkY0yGS6LaXl2NRAhzQzJl2t02YczyqBc+7g7FeE1d39b/ABYRfyyuta3LVC/1/1miDHC6POaQdfMyeib21qiTiGzRt1GgjQzMVbdyf7OKmEdr5nU2Fx2HpTo8Om3Ya02xUIwh5o1FLmGZ/LruCipkx7DyW3IuWZhdkFEw5PvnZ6xPNcCJHnHDbETGbywbQojHcyEpxoLZi7+ipcjPNtGofoOyr9G3xQQ624KpEK4oIrahK+833EwKbZ08QCCp59XctrWlBg3N8eRYxgh6SrQCKNS8ClIGlOt+jzg29eJGbq2LAGcEeRBjl8WyruTsuUcjtsDkcd7RFoIGokVKVby99wVi32klmuzutYsZFIQxOZ5cHgbnlSBIbgrrIiHTEut06t6BtKzVQOpyw1oAWSEgsYOZlj+waRQpgk+CHGL2c5WcSO6MS0DfJWuQxGBSArPo0Xf7WVn7Dc0rUES5df8v+mPbHxe/Ta2POwKzZr3fFHblJM3wvs50gCRvHwGO84u4mgO7xRobuDjjjful0FyDLEYUw1DX4bZX447lZd/jvT18D1M+PA85tPdsmSfEsotul425kffCT91zaWzeAviLelm3wAdEVAM4TpjidgPhm2UgEntqPm27INObdUHljrPjjepPy2cIvdrCdZkpa58Pl8+wtRtPkuNQUHnYnA5GoGTXQoSu7nCREhj0ekzKwhBPbx/3GE5DY7I1tS2dt5gm8rVdF4FNdJDU4VRZIkV1SRITXXlDDaQHDyMIaAfbdElLXeXye
 kbFpX/c8
 hi3l8UiceMram498L5gtgJkw75yFH+PiGIfXhVHX1LnSlXj2fsjujaZddJo4iAREZmGS2O7n/OWaAHQqKbsQh10n386xK1+kQQZSNFuXPfvcYqkyLb8kx8JPWhUUElkPUFpdhUTGbYOYuDzUSDXyKyFOem3JyYD53hqT6nqJPazVUI3AdVwSlmKwfoCnsy3q7skW+tRtpBeTSf/aK4NTx769RLi0Dl8P0iikMaPspOaEQU2dZNTCq7OlSeP5qGsU6XlMXgnlxUoys0sxYmQe/Rj0TjK0Pe7zZAlqHC8rZyvs+X8PkFM80TfEeYZkQubbanREoKBRteXfxHr2VlnU6h1IQof4DE1ivQQfFlutpDokPIwUj+LWD1BdKFQVLpn2WDYcT1SqEXm4VUpj2EpQdVlLShJdSpMqrNMSz4VhLUQWj1awBosE5Exznj/ZTHcpnIu1QVDsYQeMOr/lcGChQ7mtMbICRXH/JELuaT+0qfBHsDKBxz3HzPP4kbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Allow preserving tmpfs files that are still linked. To preserve any
> file, require permission to write to it and the file to be opened for
> reading, and reject append-only files.
> 
> shmem_luo already accepts any shmem file without links, which includes
> unlinked tmpfs files and files created with O_TMPFILE. Accepting linked
> files means that userspace doesn't have to unlink files to preserve them
> and can keep using them by path until the live update.
> 
> The path of the file isn't preserved. Like other files from tmpfs
> mounts, a linked file is retrieved onto a tmpfs mount chosen by
> userspace, which can then link it at the path it wants.
> 
> While a file is preserved, its size is frozen, so truncating it,
> fallocate() and writes past its end fail with -EPERM. For a linked file,
> this affects everyone who opens the file by its path, so a caller that
> can only read the file, e.g. a world-readable file in /dev/shm, could
> use it to break the owner of the file. So require permission to write to
> the file to preserve it, for all files. Like FS_IOC_ENABLE_VERITY, don't
> require a file opened for writing, so that binaries that are being
> executed can still be preserved through read-only fds. Also don't
> require a writable mount, since preserving a file doesn't write to the
> filesystem. If the size of the file can't change anyway, because it is
> immutable or on a read-only superblock, also let its owner preserve it.
> Don't let others do that, since the size could change again once the
> file is made writable. Like FS_IOC_ENABLE_VERITY, reject append-only
> files, since their writers can only append to them, and freezing their
> size would stop all appends.
> 
> Also like FS_IOC_ENABLE_VERITY, require the file to be opened for
> reading. The retrieved file can be read, so otherwise a caller that can
> only write to a file could preserve it to read its contents.
> 
> Preserving a file also fills its holes, but don't require any permission
> for that. Anyone who can read a tmpfs file can already fill its holes by
> faulting them in through a read-only mapping, also on read-only mounts
> and for immutable files.
> 
> Document the frozen size and the permission requirements.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261103010216.3447716-9-dmatlack@google.com

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


