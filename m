Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62624606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YxJ2kPsO
Received: by kanga.kvack.org (Postfix)
	id 4DFC16B0738; Thu, 19 Nov 2026 23:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7596B0748; Thu, 19 Nov 2026 23:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5286B0754; Thu, 19 Nov 2026 23:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 197E86B0738
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:38:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A5E5120D1B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:03 +0000 (UTC)
X-FDA: 85454240046.08.082F5C8
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7557D14000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YxJ2kPsO;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149481;
	b=6qiMEpnbgrA0q9SfoxCu5/H4e4iFK1m7mtFg21RMAwsgGi9paM6VniJ5pO198KNl5bc9Gj
	SCzNy34rDpYH/jQ5ic/mi4VUIz8tU+Mh8LfnAo/dHCKTWxBv0+BWk1cpgrT+IL9kTsaaV5
	ZylqyWiWM9gBnnMaSounF2SU4Chbjzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7/buK6g7QI/wSja3F3yrr5kbRI73yc4vQHvL0Z70sU=;
	b=YSSzrsPXFp43eZpu73QokoXsxd0eHRXFnf/yEk76Ln2jWkt57zApU7Ho9/lz8PypGoGv4o
	Hz9KqZ1+dz6sfPAiM9IKYbvHHMQUz7spdz89+Of5cX82CJqRFksk9Ry3PDDoijCkCw7HS5
	vkfxY2yKWUCZMavz/D7OqPIgzH/52t8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YxJ2kPsO;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/aPF9fCXwB7LIyQFCDkDmSR064YxzP6iZGZjFNQ3pnE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149480; v=1; x=1795754280;
 b=YxJ2kPsOCbJtqYLGpQI2iHwQKKldu1MSbbpwAO8eeoJ+GwlQaM3iPDOYmy/O5ORtO/OfEGI7
 7byZgsGuI0OMZRDNP7MTqqZNOexvpOlstETOiwc+2XbAouuUgCTw63r6QOSdGJG9eqsL4f7Sj1B
 d2etvYhU3+gLdkOSuS3zGrcc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4d7de7b7add841ce;
	Fri, 20 Nov 2026 04:37:59 +0000
X-Mizu-Trace-ID: 4d7de7b7add841ce
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:37:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <cf699b4c6b1ef0e34316d9b67a19082ee996aba7@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 15/18] mm/swap: reuse per-CPU queue readers across
 priority changes
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <c7ee52cc6aa423b40c67d4c24dcb9d30b7e07824.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <c7ee52cc6aa423b40c67d4c24dcb9d30b7e07824.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7557D14000B
X-Rspam-User:
X-Stat-Signature: 5sr15kw146buf6dpfysuyz64jset8z37
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795149481-656194
X-HE-Meta: U2FsdGVkX1/d8F8x8Ze50/Z/9f9v80x1MpbofWfOqBYdClDZt63rMItYqnX1tX2qXShhvTmG/aYXZ/6xXwaWngcsQ8Wq3lwGAZPErR/VQECiLCMhuOJPX+x60uDbTx8j3M0V+LClASVzXxuQTcndRsoYAS1b9FmTboL/orV3Af+wqYWmRSYh2wYajbBNRLLx+1Iad09zyr5jQfNZhkRYFb8ixohvCWu5WE0LUMaql/rEjtTGsPHjBba+E5PFcDb0uoiZqVTElcCAf1KQollnVLWk/SmYltl1+q39w4hjqpiO9NF3JiZfeA5EMOBnAWpyfGV/IIAnMlaHCbgLAn4h5+WjKzeiQ5S7JLWm+EQJAS2/iOjC+TPz6hrrN0jy50nMYZ6UA+WScYaW35mg3zoD7/RVUM9laCFoLY48cbDBwFiiubGBcPgpUxTKwjUxXk6XtWt5ocfJ6lrYLNIcIijE1rjvrVNBcwak9g2Dl8v9pFBfHjS0VxyQDsZMLra68pJRDu0JuraL9GnlAqsBADwSqecU53du//h/LicVFuXSym0MtoJCdb6WzJq9AO7oXhz7tL/FVD4I+cJFSav/01KGZmetgPZxpV85Ku1J2GzjT0HPIDIgtiZE/aswoUiqufmth6igvba2DASmuw+w1XxK/lh0n92edQ3NXsYauwUmr9rBo9WD7eWs6HYtcSHGa0f2nmHk6j83HCUB4nSD2X5AzMw6t9x4SnAjOPAKjQE26roVBJqFPKvVlF4TYcyapakb89jKMJCvAGKUMw3iO6w+s+gUebHgFSXCo9Pk8DObR6AisAlywuNUDrXvCwlk7AHTEykbiEFW9tVa5IfHdIvSBTC6ow/S62x8VkYB6PYZk/2/na9ASFY7UQkpPaVSj1muOID+VgCS6jPLzdEchJ8/vScsUW+l46WLR408+xfQysFvl7vvf7HS2Whio6xF9Brdxbb/9B1uM0dQxBCZNyI
 x2M8cvcu
 dTaadzVIG1GUbUIVAL+4c/i3ivV/M87daBZ7eMaK3vnAy5hiRqqPmSTHgoW+R6jKa8WTxioTOIhaYXC9stAsS76X/OcdVyMjmPoZFMuduve3w85O1FIfVutBOQ8Mqoh7zb57ZF4Rv5J9ZBWRD4loC5IoLQR6vq4jpDCIpwdv//IG2h1MgN6bD7rXtjddSMy6mrfmI2yX1BFdj8Iw7rKgsGf1jQ33eTJpto+VHZCKHiDjXVQY168TYO93iTdyBy8EL5d72A24DejKgd4eBd4IHfQTdhO4mhTrxt2tlu3LfoMXlMNZ/8zka8f0/SkyNyiZ1KMc1MiXYpqEFRopvniIiWypqdgbRsJ/VFBqV05tBkU6AG9cAQigWQHXQm9OUVCWPd06OGEwgjeZ0xjsOtFaVYH3Qzlb2SUhi3hoSR+tj3s1bV7CxCKQrP/JQ15vSoJa7Dngm2feSZJl8AD9aXisZOMdMaQ+RrlkQThKNzo99RoRxId/vIH4843KzD+VmDJeRrXXEAezuv5Wg9DpO1FM4/c8b+cUbRDM864za7SyDC4AUInfvpbV8OUCKJYK6LO7qNXvmdkyC627kjkM=
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
>=20Inserting a new priority allocates a replacement per-CPU reader array
> even when earlier ring removal left enough storage. An unnecessary
> allocation can add swapon work or fail despite sufficient capacity.
>=20
>=20Track the installed reader capacity and retain its high-water mark
> until the queue becomes empty. Reuse existing storage when the new ring
> fits, initializing every valid ring index for the new topology. Prepare
> larger storage outside the writer only when growth is required and
> recheck capacity under the writer before publishing.
>=20
>=20Preserve the existing prepare/install ownership and failure rollback
> protocol. Device removal continues to avoid per-CPU shrinking allocatio=
n
> under the writer.
>=20
>=20Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index bd098114ee4b..5e5c1aef010f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -202,6 +202,8 @@ struct swap_queue_cursor {
>  };
>=20=20
>=20 static __percpu struct swap_queue_reader *swap_queue_readers;
> +/* Keep the high-water capacity until the last priority ring is remove=
d. */
> +static unsigned int swap_queue_readers_capacity;
>=20=20
>=20 static inline bool swap_device_masked(struct swap_info_struct *si)
>  {
> @@ -241,7 +243,7 @@ static bool swap_queue_needs_readers(int prio)
>  return false;
>  }
>=20=20
>=20- return true;
> + return swap_queue_len >=3D swap_queue_readers_capacity;
>  }
>=20=20
>=20 /*
> @@ -289,13 +291,15 @@ static void swap_queue_reset_readers(void)
>  }
>  }
>=20=20
>=20-static void swap_queue_install_readers(struct swap_queue_reader __pe=
rcpu *readers)
> +static void swap_queue_install_readers(struct swap_queue_reader __perc=
pu *readers,
> + unsigned int capacity)
>  {
>  int cpu;
>=20=20
>=20 lockdep_assert_held_write(&swapon_rwsem);
>  free_percpu(swap_queue_readers);
>  swap_queue_readers =3D readers;
> + swap_queue_readers_capacity =3D capacity;
>  if (!readers)
>  return;
>=20=20
>=20@@ -432,7 +436,8 @@ static int swap_queue_add(struct swap_info_struct=
 *si,
>  }
>=20=20
>=20 /* No ring at this priority: insert a new one at pos. */
> - if (!*readers || nr_readers <=3D swap_queue_len)
> + if (swap_queue_len >=3D swap_queue_readers_capacity &&
> + (!*readers || nr_readers <=3D swap_queue_len))
>  goto failed;
>  new_queue =3D kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), g=
fp);
>  if (!new_queue)
> @@ -460,8 +465,12 @@ static int swap_queue_add(struct swap_info_struct =
*si,
>  memalloc_noreclaim_restore(noreclaim_flag);
>  kfree(old_queue);
>=20=20
>=20- swap_queue_install_readers(*readers);
> - *readers =3D NULL;
> + if (swap_queue_len > swap_queue_readers_capacity) {
> + swap_queue_install_readers(*readers, nr_readers);
> + *readers =3D NULL;
> + } else {
> + swap_queue_reset_readers();
> + }
>  return 0;
>=20=20
>=20 add_to_ring:
> @@ -504,10 +513,9 @@ static void swap_queue_del(struct swap_info_struct=
 *si)
>  }
>=20=20
>=20 /*
> - * Shrinking the small topology arrays is optional. Keep reader storag=
e
> - * until a new priority is inserted or the queue is empty: per-CPU
> - * allocation must not run under this writer's noreclaim scope, which
> - * can grant backing pages reserve access.
> + * Shrinking the small topology arrays is optional. Keep reader capaci=
ty
> + * until the queue is empty: per-CPU allocation must not run under thi=
s
> + * writer's noreclaim scope, which can grant backing pages reserve acc=
ess.
>  */
>  gfp =3D GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
>  noreclaim_flag =3D memalloc_noreclaim_save();
> @@ -550,7 +558,7 @@ static void swap_queue_del(struct swap_info_struct =
*si)
>  swap_queue =3D NULL;
>  }
>  if (!swap_queue_len)
> - swap_queue_install_readers(NULL);
> + swap_queue_install_readers(NULL, 0);
>  }
>  spin_unlock(&swap_queue_update_lock);
>

