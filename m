Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307F8606D801
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=b9Oe4JoZ
Received: by kanga.kvack.org (Postfix)
	id 30EF16B05B3; Tue,  3 Nov 2026 19:43:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8476B05B4; Tue,  3 Nov 2026 19:43:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFA76B05B5; Tue,  3 Nov 2026 19:43:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6BA46B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:43:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0252A81B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:54 +0000 (UTC)
X-FDA: 85395589188.16.ECC03A7
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE6B8C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b9Oe4JoZ;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753032;
	b=FG/i4S36LIxxer3/UbT79zdv7+KuvgReZ8HY58gDXLgpeDLdO5V22wkfDvwsSgUuRmT32q
	Jiw6dEz2hyXl8Xmvfr0Cqv9XquivNU+zYYauwCnF4+th8DnG/OrUUHAu4zy0W2u4CVXcfI
	HiEz3igTsI8LO92L3peIh0g/qgE4pig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b9Oe4JoZ;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRXI5AlbB9KpB+65wVIGCYZD4BhZazr9WIMOqzWe5bM=;
	b=3DlxwJ/I/AP7CihwBzBZpo6Y/nvZ0pz9JcCoQEohXnSWADzyDeI3Q+IgfNmoPVdpPN6bSD
	OZQghL4y6IgtwDZuGPfN9YlBUdTXqLqcvQWaRTy8CRKjhGKoVj7zmweMiak5jF+tOg67gk
	FDwlmVeo5F+GEiynnIcESqyzhcOqtBk=
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-98301b325c4so47475241.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793753032; x=1794357832; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KRXI5AlbB9KpB+65wVIGCYZD4BhZazr9WIMOqzWe5bM=;
        b=b9Oe4JoZdUQXjw4R2B4sqcZ6fzIPJ5KHWb5xcj86CjPq50kz3z7+JPR/0Oa/pvmDt3
         4Q8Rqwrpqla9s5eE5LC8yePDPBE6ckziz7+FJiOmwbOdoyyKexzlYGgqjJmd+OuQI53E
         f0JPEumGTqavp7usC7zKJit5qZihyQGNzy4ZDDq2rY+uUxTOv7y06I/o6laA86If3gZT
         To5HHB4XmrQNvBSx/8aS1VOcz4JfgI8dDEoqiG3r1YO4iBqyVgUaxkQMdp4PxpqiP1vT
         bdtPRNZLzNsR5i1m8ZuW+2iU2Hnp8Yc1ulYNA9mdr8SCIpCt9Q2AyxfhaS7O1XHbm30s
         KVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753032; x=1794357832;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KRXI5AlbB9KpB+65wVIGCYZD4BhZazr9WIMOqzWe5bM=;
        b=vlqZ1mjaMW6zTj4Y8TdvIceG+tEZQZaChNJWcanN7QuUzOS9fZEGk+Pf+5Wt74VJQP
         WLx/l3O4arBEi2gWfMyod2KLy5CSKE1VgCyOKRaGi6AA3Gp7KUpueh5z5fAcfoteCNYw
         jDnytg7cFVB086ebZ5Dj7pAzUxw7zOxlG5TyIkcqKyz2TSgheuMX59y5VXhy7zI8udc3
         KC6GsIp+jqs9TvYwrkoquayZVPybDUjpdPxWt1K6klSfZ44BSuXpFecdmQVHMMFvJjSS
         wHJrW7zwu3dn1mo+zrCeklbdgEbXhH1VrHYUNv0e4jCNGJXxKzEI/scE6NFWA2wuQ/MX
         edKw==
X-Forwarded-Encrypted: i=1; AKwUvBwkCf7XqV9xXJKgfWj5t113Qbhs9Hxpp8ZK3bDK2zdwN3UpsNcK2oWYQ3eXUZy3MSxlm6gaXWMzzw==@kvack.org
X-Gm-Message-State: APuU4Z+iSHMzXwrKZwQbL+ZYXs0Cgt3OofvMZstwCBhCNKwGWXfu6H89
	jT5RfgveXcMy/QUF0dA31uDJWiRekMb9sjHVWHHzjx9QCKpgiEJHM3XH6CafeicNLq4=
X-Gm-Gg: AYBFou2YOeyZXXhLDPn1lNAy1O90aehX+mDvfOj6L2HMLNvhHwMpNBWqJrTnaQt3U0H
	umd7iYF46p6hnCyh6JKf7nAs+ToHzq/4hflYTt9KlL2ekCPI1VcQC4/hOjhYPn034JpQ/K6Palb
	M614a3WcoFb0SCjeHyXwrB1YaYo0A5XHV6QEOwkIuNSrMr1+Gdeq7GvvSaxobyDzmq12a14oggr
	gvUO4+jvw1H3pG8Y6htluvpRfr3vi5gQ3UkWqnw4+GQxkJqgbcPpj1JUDasvtH5F2m6vuzJZuUw
	15YhXAUbjQfP1ulT5U/tmvtqZxfHpTsAZuRfdlAF/g/kPcYaQCyueK7IoI91vhX+W57FU6L7UVn
	9jYE9Y327kJMkz4plRK+DurfxR/6J3WuAupTmxPfYYBx4n5K+K3oupjaY6RZXbVyt/iSrZEKf99
	1ctr1o5SWsVTi7GB8mlan9R4pXQ7migYmldLxXYBEn8IOnaIqBqGpZRxf3NJlz+qfPwPtkUCrUR
	zePjcX/ca8hit6gyrZcKI4NDxm+dtqnG+EL6d81LmH8HjExCXcF0Y1riE6ySUHyZ/uXlcjns5OW
	b/QU32ZjNwhOp3Z/qvbwscE/oEIN6C+fQsZoPdtnQbBY+LTkS8HDMlfrsnjn/5aGCq+sf3llVV7
	np3TNwkFEpdb8T6PCKyZyC3givNsdm3afNrUWscRs1Anj
X-Received: by 2002:a05:6102:4a53:b0:7d2:76af:fcce with SMTP id ada2fe7eead31-7d276b006bamr791137.9.1793753031752;
        Tue, 03 Nov 2026 16:43:51 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fef4ed3sm527432137.11.2026.11.03.16.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:43:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 07/10] mm/shmem_luo: Retrieve tmpfs files onto a
 tmpfs mount chosen by userspace
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
In-Reply-To: <20261103010216.3447716-8-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-8-dmatlack@google.com>
Date: Tue, 03 Nov 2026 19:43:45 -0500
Message-Id: <179375302574.727293.14537040566857910268.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2542;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=vqAe2yDDLEwKgdF25FVv1O+wpJlIipaSEL5hDK2VqOY=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6n/ET4OO45vZ6StOR902DLzVLY6Bj7770P8sb
 nnjgwQuckuJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaup/xAAKCRC7dyhM23N6
 3jnJEAC0kky9VSu9xkI04nj8RiMbjwZNaipgbM8c84yf/wc4An6yU8htiqArYikDHsF3LbfOPIu
 ZJUI96h+M87DI496Gg92JK+uzFrY3uJjoyYr6us6+nUjcMcRYRWUS14WbhTxF7LoVgCU7SpDi1V
 MK7oieNjQXNfVgW/NL+Slwq5olNJUkvSgPFiAU8xQjVJxJHLYJmIJIXxc5vrbOVfL7YzAy7OxvD
 NuTg0ha8GM19+ZVxhZjYxkwGpmHD/eqTqJKoDVST6z17DZBoHHTbkpvXEHEsHmPCJhdTnBwejzX
 hbQEnk5/nzD5A3xC2edrsjyws0b8KclIaBJ4mNo4RtHUlelIO/ETzlvNcSmgpx/32KI74IwNr0z
 V4G6BxZrPeQ2TvjDEOTsCOP/lKsVlCx5YHTZYdhgmlBgR//QxXA76UCWPPpy0P1U4kNlZyNH6XV
 e3oMwZs1iPhhtd9+roQtAfbc6IPf+TbFCwI0KxQyxKaJvIxQQl98TA9L1QxJK3Eu32Hg8sqs8ED
 afWk9iPUD+ACfrf9HgHLFHlyw6RWtNm1UGEI9lvbzR1iPJesYxMSuVxfAANKfyZIR1g/hjH50H+
 OTddQgi8QtOA6wOiO+tOIvWJWdjD706Y4+8m7qxO6a0u8szavw1N/NXcclT2ViuQIaOrPcVya3z
 1YbZ7UGOm90VVsA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: kmugh4m4yf9tnqp81u1omecxpceezbab
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE6B8C0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793753032-202612
X-HE-Meta: U2FsdGVkX1+RnQpT5DuYwjQ9ZVyDn2Hz0F8mgpmb/MfRPr5SzuFF+Aw7mdXVRk4/bYL5eaLLE+Qdym3b8cHGvrqhlRgivuAnObzdoWrI/Boh8nd0i/lYElxbG3StxH2UTnFbSCMCmkW1N7vbLLYhaP8dEfHyyZgRwelW7mwz72gDvfcBtcQk+vmKovk7EFU5VAQZxBt3bsg0VFAY/2c3K0hmSfrFebVQzjEJE3kd9kUEPakaqbNBRb6BMb7ou/nveTLdBK9cQej1UeXm6Dydz8k42Pn4B3gtcIsuN6P7wBNyzUwUnJpDiQKQhfVXBIi8eiPQ77vvYYTlkqZH4dIAmxIM23KWS+VBEGLaFlxY6twEBySTTECB07D9xu5KYZ1+m6r/3RL0l4MBT9OgOZHv9/TS90uHTs+tqYzk6o4MV8jSz512jE6Z2aDZDQcYBjKbD17Fxi5dAkxFQtWitU95T4oEkXer3pY2/tAIyVz8AyxFrglJJ07Nxr7IrGdJdASGLiWFyhL3kF57iSptnAzWJvtLeNT1a33JPu132QDziKu93QO02N/zUSFv9N2EgzKY+1n0kLcvFErIKewiPJl1FK/hgSSDtv+/1/CBZkfZNHZUqBodn93xiScMqUnSQ/eobLpa3GG5wcOo+bpxpPB4iN3DgFKjfoSmPRf42T/aQBGgyml745GceKTuGngKIBXpUpi7kdwcE/RWV/KAV6w0l3DVd8BgmhkEE3aYfpwgEd1Z1gQsEub9LDHhJ3z3FKXkh50ZpOSrOMFUlE1EkGh/ZykauVTYbSO2jW/lK57r7upw7OejS/LFxPTHBP9vDdIeIXbBHKpQ4RxHTg3yHrNdJcrcJlcyTBPXgPTfALbMzkc5AdSMRJP8csDhbxekxlHsXhnVZOklm/nTYd+GlpkSdyYIwK1C90dobnM1QuXe92kxNz/oup7zIcJpUuhv3iFCHfapF2SBJZRUE8NuUSO
 qaIBgemT
 VQZOnZLPqkku7VdxfzAxxLlmjLIT2E6yf2aQnlnGuCf0/SUBbczez8r0SHPsgMZ3h9NJNVm6PMN5nXt871lNQclM+yDuwu1cYBf3cXjvmVvzrmNsw69BVw1gCKVvUEbB5ScBDCqisylccHXsW1Yt6v8O+UzukgI71jz5qVfBpShyQfXhkgS2pERJ4ruPnztNW1j0XCSZDGCQuYThlIzstdvBjH8fw0TC9S26JQwYJEPQJjsDY8vJC4OdWF7rkOOOdgLYbdRSJo83NAnZZvP6V3j23ZJo0PbfoQc59PDQ2dEp/9Ny1/zxUNO1Z07NrYqwe6lT3Av5bJ2aOHcBBHsqAcUlPslCT5j6exCoExbbdb+fwtH60vpRWk3dsXWNDECNlFa/1aPyqx8v73D83czt/UHnzT8WWTT5dNh4vkvlEveJ+QYp5zq76zVYkVsD5K0DgkC2siqIpSjze7CcyhsqglN0evtK15CSkFgh2hjONYQUIY5fSpUj2tgv1ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Retrieve files that were preserved from a tmpfs mount onto a tmpfs mount
> chosen by userspace, instead of as memfds on the internal tmpfs mount.
> Add struct liveupdate_shmem_retrieve_arg, which userspace passes as the
> retrieve argument of LIVEUPDATE_SESSION_RETRIEVE_FD to choose the mount.
> Record which mount a file was on with a new SHMEM_LUO_FLAG_TMPFS flag in
> struct shmem_luo_ser, based on the superblock of the file.
> 
> shmem_luo already accepts unlinked tmpfs files, such as files created
> with O_TMPFILE, and a following commit also accepts linked ones. The
> mount such a file was on doesn't exist in the new kernel, and userspace
> may want to put the file elsewhere anyway.
> 
> Model struct liveupdate_shmem_retrieve_arg on open(): The kernel creates
> a new file as if by openat(dirfd, ".", O_TMPFILE | flags, mode), so the
> file gets the owner, permission checks and security labels of any new
> file in that directory, and is charged to that mount. The kernel then
> fills the file with the preserved contents, size, position and seals
> before returning it, so nothing else can access the file before it is
> complete. Userspace links the file at the path it wants with linkat(),
> or passes O_EXCL to keep it unlinked. Neither the path nor any other
> inode attribute of the file is part of the preserved state, which keeps
> them out of the KHO ABI.
> 
> Pass the flags from userspace to file_open_root(), so that the VFS
> checks them like for open(). file_open_root() silently ignores unknown
> flags and mode bits, so reject those like openat2() does. Also reject
> O_PATH, with which file_open_root() would ignore O_TMPFILE and open the
> directory.
> 
> Keep the type of the file: memfds can only be retrieved as memfds, and
> files on tmpfs mounts only onto tmpfs mounts, so that e.g. a file
> can't be moved off the mount whose size limit and quotas it was subject
> to. Passing the argument when retrieving a memfd, or not passing it when
> retrieving a file from a tmpfs mount, fails with -EINVAL. Unlinked tmpfs
> files were retrieved as memfds until now, but nothing relies on that, as
> the LUO uAPI is not stable yet.
> 
> Like the other failures before the folios are restored, problems with
> the argument and with creating the file can be retried.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261103010216.3447716-8-dmatlack@google.com

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


