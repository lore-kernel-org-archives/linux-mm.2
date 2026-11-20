Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2F8606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Fi00uIZV
Received: by kanga.kvack.org (Postfix)
	id E7DFE6B073C; Thu, 19 Nov 2026 23:38:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54B96B0754; Thu, 19 Nov 2026 23:38:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92596B0756; Thu, 19 Nov 2026 23:38:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A21716B073C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:38:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21331A8C0D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:25 +0000 (UTC)
X-FDA: 85454240970.07.1BDDAF4
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D24F1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fi00uIZV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149502;
	b=b+Bh9UAjZBefJWxGpCKhUUnJ6Ks8MngohxZaNLug8e0o+KIWLahNni92qWBD9PQgyCu/Jb
	Wc/oC+ff51GzzeoCupGR23zkhq4FEfAWDACblRJswkJAUZa0dTSx08kv4jIhgcNhEbZTPx
	/cC04oNlOk83LmOt/6YYWljkwOYkhpA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irA75ClnVJ+YMTbg6ex+HmOU4aK2Uha/DYvHWc5mkEk=;
	b=Hbr7rEK90EX762UbOjGPg/PNJush1mX/kHrwSPvBci/zfBCi1bMLGaWfr7BdNLC3YfLLyJ
	RG1SixIC4UINJrn5gbW6OEul6QJo0Wu1ZiCQeYD/j20g6ZMXSHwlKbVojqbPW4/EhgDppf
	1uzZ+IlPbcj86737urCzR3e3+vobVrc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fi00uIZV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+0Kljhew2K71A2N5GrXQl5JxNv8YQpGFqu7PaOwFBDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149497; v=1; x=1795754297;
 b=Fi00uIZVuJdM7sXviSJNMPxkGTlDZpY8T24aCugw33eW1a7maI0G1h9vx5OTkN0rwYfAgKNi
 HFJCsM0Hi9AFUBncvG1f6CaMC61itRi118OnK5TIRVjATX45mqW6L5KFRdjATSseuSUrnHrMLOk
 TOjzoEnoVEVaYtaYEzzMu/zk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f87a44be2ecf5d50;
	Fri, 20 Nov 2026 04:38:17 +0000
X-Mizu-Trace-ID: f87a44be2ecf5d50
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:38:17 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <1391b9e3f25f7f95aedd2b884a998a0d48b324ca@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 16/18] mm/swap: advance the global queue cursor
 directly between priority rings
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <e72074ac198130494037e80655685cf25ff4bb5b.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <e72074ac198130494037e80655685cf25ff4bb5b.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D24F1C0007
X-Stat-Signature: mwhd55wiz79cuhh6tab4hd8yejw44nze
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795149501-81044
X-HE-Meta: U2FsdGVkX1/dMiO2ljEDLCJXvlEFeUosKWFbv8Mhta0/qMIhcGkqGqUEW0hQ1YqwdZyS4wDJw+pKxJ6D2nRnw3W2uvIofjkGfgUSXOnJUkjzBePB4wdKMyWpM9PRNgaV0LWvqhnPvaFIkt4ulVNL4hUkIwfm34EXQF4ABapMq24hG2MpyTq2Nlip05hPKHU3oB7mB++35jXiQ2pgsv/1ParfMBuhBFjm87F0KXD8sa7Lg81TqFctvGwxG0oIcVx0iz+J8yr426NUkywBUAeNwbm1e9MX6J2fBzNS+Q30xCSUQ24eREXvyxc8hheyGeKuWdrwOIEjui/2ZIFY9t3DlQ4iqFW8GorAHE5vohY+fyHJGSrr08lcQo0lzrlJcaov41OuX1KsRP9NbIfN8hdfTfARyeCyMgWJDksdc6LuMUb4+iT3OwaIjwFSaRPCT1N2jhpFg0G2QN0s7JVRiJfpeClGvegzlzCKH3Zdx87aXNagenAXRSdj6VIg8EX9aQpWGKDMIVFdRUQgJ5d6nXO+Ib63Br0cFNN/NV6Ee3UCzRwlHWSWcA53iThFiBXKBAEkAiJNJJx/q3vyA4tPj9HMJIHO0xCaTL4BslHm+DsBRhb0UaTGOTIZjq8o4Ui8jZK8v3YmjKxe59go5sl6JKqSHWBpcd8kVLht6vUwchhTsBxAU2RlKkLB1STTxJdSizP/Uv+gjVRzUvjpuXGqe/EwLWyhk6Db5f9yPi/64YaXjgnYnt9CXVSz98UbKdI75PpC3O1lnfuFvj/gj/TPj/rYk9BWdn7wi5YlcSX/QKsZzeFy44HOtqkDLm7cMBpkFoDY3CDh6RmYbbOWTAHYpfY2e2o7+JkMmbUd+hGRhVzc5XQUrl5NIeVb32Tu8BHn+1ywhftwzw8zpr8IQks16jgkeDgDTAg2jxgom9KS3pzXBI8AjtVtmOqJnqUT3GSEw0PLh8G1Cd1eAViymmvk+NM
 QkEEj6yr
 dNRNwZN7vFmsjCnYo08x7WP7N1Fh2boCm5ZJD1qBykAe1vCuGqbmJEP2Hcil5yGM9aQ7BpUDYLA1cg67vAb1EQtz+Wi0icOCp9A2bUJYp/a+dsSENE46X3iVZsPhA5bQdZTQjt0rgBWNQGkXOeGJGfSlnUXLzCjdTSaLcaLJoryj48TxzSbSyyiYpPUwmhDlOOfO5MYfj+sRKXNtR/BbTcSlA5vD+vaqB/ro2w2BOkhnv3ARIn3jGY/PckoKRF3djBseMV2m5NjLWLVBCyL20ZdEMN9lOVTQSNV0ZF1SJ9YdLvyCWatPnK4a3eMIAc4efQJ7h0ijHP+2ODf343c/Yank0RWdwj/1GXq47dTSxWMqLcGjLV173nngG7cd8MnqA89z4Q+5ODuy+2v663teL6f7A0+fjPUh8y0aONRY3sLD36roZKVDhJrIwS8UHe6AQmNwmOZ+RE9wTud3tFkSaR9YBdU6vDAPBECrMHgFNyR1ofnUI26iocTKGfxOLFABoJLntQX/l5xLCWWEnJWwD1KekNO8sc+Vo43tpNsCCnhnW5mBxMUUGxpHM10Cdl7RNy3iMhj+CojJSaSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20The allocation walk previously passed a total retry index to the sele=
ctor.
> Each retry translated it back to a priority ring by scanning from the
> beginning of swap_queue. Keep the ring index and the number of attempte=
d
> peers in the task-local cursor instead.
>=20
>=20Snapshot the starting device only on the first visit to each ring and
> advance each peer exactly once, including masked entries. Preserve the
> large-folio same-ring boundary and the stale reader-offset correction.
> The selector's complete walk is linear in the devices and priority grou=
ps;
> device cluster scanning and availability updates have their own costs.
>=20
>=20Keep the topology read lock and CPU migration protection across the w=
alk.
> The global selector uses only existing priorities and adds no per-memcg
> device-selection state or ABI. Existing swap charging and limits remain
> in folio_alloc_swap(), whose failure path classifies allocation errors.
>=20
>=20The walk no longer returns an ignored internal error to that caller.
>=20
>=20Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 51 ++++++++++++++++++++++++---------------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5e5c1aef010f..616339c5ae5b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -195,10 +195,10 @@ struct swap_queue_reader {
>  };
>=20=20
>=20 struct swap_queue_cursor {
> - bool valid;
>  bool ring_only;
>  unsigned int ring_idx;
>  unsigned int offset;
> + unsigned int nr_iter;
>  };
>=20=20
>=20 static __percpu struct swap_queue_reader *swap_queue_readers;
> @@ -308,28 +308,32 @@ static void swap_queue_install_readers(struct swa=
p_queue_reader __percpu *reader
>  swap_queue_reset_readers();
>  }
>=20=20
>=20-static struct swap_info_struct *swap_queue_get_device(long nr_alloc,=
 int nr_iter,
> - struct swap_queue_cursor *cursor)
> +static struct swap_info_struct *
> +swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
>  {
>  bool rotate =3D false;
>  struct swap_info_struct *si;
>  struct swap_ring_iterator *ri;
>  struct swap_prio_ring *ring;
> - unsigned int dev_idx, queue_idx;
> + unsigned int dev_idx, queue_idx, nr_iter;
>=20=20
>=20- if (!swap_queue_len)
> + queue_idx =3D cursor->ring_idx;
> + if (queue_idx >=3D swap_queue_len)
>  return ERR_PTR(-ENOENT);
>=20=20
>=20- queue_idx =3D 0;
> - while (nr_iter >=3D swap_queue[queue_idx]->size) {
> - nr_iter -=3D swap_queue[queue_idx]->size;
> - if (++queue_idx >=3D swap_queue_len)
> - return ERR_PTR(cursor->ring_only ? -E2BIG : -ENOENT);
> - }
> - if (cursor->ring_only && cursor->ring_idx !=3D queue_idx)
> - return ERR_PTR(-E2BIG);
> -
>  ring =3D swap_queue[queue_idx];
> + if (cursor->nr_iter >=3D ring->size) {
> + if (cursor->ring_only)
> + return ERR_PTR(-E2BIG);
> + queue_idx =3D ++cursor->ring_idx;
> + if (queue_idx >=3D swap_queue_len)
> + return ERR_PTR(-ENOENT);
> + cursor->nr_iter =3D 0;
> + ring =3D swap_queue[queue_idx];
> + }
> +
> + /* Consume masked peers too, so every walk remains bounded. */
> + nr_iter =3D cursor->nr_iter++;
>  local_lock(&swap_queue_readers->lock);
>  ri =3D this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
>  /*
> @@ -337,9 +341,7 @@ static struct swap_info_struct *swap_queue_get_devi=
ce(long nr_alloc, int nr_iter
>  * iterator can move between retries, but the cursor must visit every
>  * device in the ring exactly once before falling through.
>  */
> - if (!cursor->valid || cursor->ring_idx !=3D queue_idx) {
> - cursor->valid =3D true;
> - cursor->ring_idx =3D queue_idx;
> + if (!nr_iter) {
>  if (ri->rr_counter < nr_alloc)
>  rotate =3D true;
>  else if (ri->offset >=3D ring->size)
> @@ -1847,29 +1849,25 @@ static bool get_swap_device_info(struct swap_in=
fo_struct *si)
>  return true;
>  }
>=20=20
>=20-static int swap_alloc_entry(struct folio *folio)
> +static void swap_alloc_entry(struct folio *folio)
>  {
>  struct swap_queue_cursor cursor =3D {};
>  long nr_pages =3D folio_nr_pages(folio);
>  struct swap_info_struct *si;
> - int nr_iter, ret;
>=20=20
>=20 percpu_down_read(&swapon_rwsem);
>  migrate_disable();
> - for (nr_iter =3D 0;; nr_iter++) {
> - si =3D swap_queue_get_device(nr_pages, nr_iter, &cursor);
> + for (;;) {
> + si =3D swap_queue_get_device(nr_pages, &cursor);
>  if (IS_ERR(si)) {
> - ret =3D PTR_ERR(si);
> - if (ret =3D=3D -EBUSY)
> + if (PTR_ERR(si) =3D=3D -EBUSY)
>  continue;
>  break;
>  }
>  cluster_alloc_swap_entry(si, folio);
>=20=20
>=20- if (folio_test_swapcache(folio)) {
> - ret =3D 0;
> + if (folio_test_swapcache(folio))
>  break;
> - }
>=20=20
>=20 /*
>  * For large allocations, try every device at the same priority,
> @@ -1884,7 +1882,6 @@ static int swap_alloc_entry(struct folio *folio)
>=20=20
>=20 migrate_enable();
>  percpu_up_read(&swapon_rwsem);
> - return ret;
>  }
>=20=20
>=20 /*
>

