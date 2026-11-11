Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D69606A894
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=F6fon59q
Received: by kanga.kvack.org (Postfix)
	id 931556B05CF; Wed, 11 Nov 2026 10:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2DC6B05D1; Wed, 11 Nov 2026 10:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1956B05D2; Wed, 11 Nov 2026 10:37:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5498E6B05CF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:37:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB2961A0362
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:37:44 +0000 (UTC)
X-FDA: 85423243248.10.A86FAD8
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13EE5180005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:37:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F6fon59q;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyPyNsXNnyLp0wiWkbZYu4vFk3ow/rtQP4zegoB1/BA=;
	b=B7+QPIlE0hpes9ZSx7NXHrzUkOtmtMI4whUtEGv2iAGVPFfOvSaT0oQ5NiIAk9Ke10ucUE
	ecag/pKTpi7Ksvz/YV8vrdoVNrJ4BTGnG8Wp5gx4wC3NZrYOyYCCLNS8RVf9Q34Q7S4Q2a
	6rxowtrMt+/cYlzCn+3vL2v7w8JImPs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411463;
	b=Jc1PKQVrvKcklP5R811qN/PbRLFtQIFMo8zkWSYZPz2v/INUpV7FE7t9uuG1GiaEk0aaqe
	qiQUEqps03siKMcJhx3AA3dR/5KlKXt4J6GRemTYUUSzk63qsIMHCOExW1ehxQAjOUsRkY
	hq+1tLwRwgMgwmn5jdjMT+lrbxVV59E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F6fon59q;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7777fa8f1ccso1161621137.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794411462; x=1795016262; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zyPyNsXNnyLp0wiWkbZYu4vFk3ow/rtQP4zegoB1/BA=;
        b=F6fon59q43TlZR+Q/IMA9/V92/Zh65O8iICZ9LjPVxsfhOuc9GN0DLMJauqAfGwDOq
         xZzCB2oqHn6CmwVityk41BovMeZIJ1kxLx+sW+0gKAOSHqgvnK52FPonRSeyK62EW0NM
         myeFU/ddRxYg9jpfDDD/nsDzqoTR9ftG/MdZUX2mHR9aXGof9VhavRMop8cjgX6upw0F
         N9tbRfbKjz5/7J69jLvfL69WluNoiDcsF1rpdnoW/KZMwGVjrR5nu6f2NdoqovHlPhRy
         lU5pb2A0DYqLgnyQL0kVDq+zcglIKSPp8rzrLSsqeC+zYIanq8Xt7PqNd2qSwXwl4RHS
         MT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794411462; x=1795016262;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zyPyNsXNnyLp0wiWkbZYu4vFk3ow/rtQP4zegoB1/BA=;
        b=ccBb8Kd3DQvMk9n+Fc72AvIXRwMiuunktz8xDqzDDLx0RMBwlLveVRpfN0kmrPevGc
         1CjR/YJAnf5lZ8u+WLsqArpaMKyqpshXgenBK6rWtu4caAQGxTH902GTkJW6Qf7ZYagq
         LS8m5MAgY9VjFMQHMr6vAfXKiu8zpXzHe+TQqv6HPjyxJhUTs8HcM8+6m5gO53+xLZul
         AXe/K7BNr6tMqHfQWts9BJS8PJsMpUVP7qWO7u4zTFAykOKe9u6+Pib8ihHfeDhkiE6s
         eF6HrqhIFHq5XHjVfCvpuaGx1teSFciWEb6e4XwlDinh2IT/3SqJ8TkItB9xfBcT63Dp
         XCSA==
X-Forwarded-Encrypted: i=1; AL+hErEI+YnMUoCtgGb6oMXQDs1ssACkSHpYn2sayVIXEOAYrLn9PPlcCI81zm86ePBmGgtNCKkSgzvoag==@kvack.org
X-Gm-Message-State: APuU4Z8vuQnRn1mgH2sZXCPad692nYY/L0VkeJcfhnyxjc1srQhnZk2Q
	4TQ95PHukKS1Pre8AnjYCZ257yzCQU5R607bas/3BEd7YY1oef9dykuEyhp+csrDHi4=
X-Gm-Gg: AYBFou1bZDNQwYEzr6RbamaeNpbhRhW5NIxmP2dgEC+3H6lso9WmZVHhfX2BjA7vCKl
	60aa2pD8KVG5VZpZV/UW7XsVP8ig36ztD16RisLreXg/boSSwkKDsx3dAoWvYgYcOU1to39aDGU
	YKylzEs+khRBnG/9qsa7OhHTSi055fhucwHDCFC7YNhj5w0mApGwMHIlhBQWkmch72khf420RLS
	VsVOwomvnfiHkwtZ+3eYQnvwdfzjiVV0La0XrLAqfyGbNeHTvl75Qsx5XY+tBCxi8z3iYc2inTh
	35zv1jb+wc1M9K5UqX6JMJbrSTSmEU0h5NmAXGyU8Hqnr095+boLD6bnQrN90K0BHP8gFXh4DaU
	8Z9bbYpH7TStBSOdO745GZ7HKP1c7Z8msE4KDD1bDuO4tp977ezWRZasuFblJ2/qdWIu1mxTBUY
	9NbJ6A6ZH9pelWkE7CTtbvrI6HKxBWRYm3onUZDtsHRauMMgjotQUu+HNgzED+PR+iZKHJEniDt
	rFU8T/P6CYgel8LdYma0hLFTL+S4kKDYJQWfkkuu/hVqGO2cCzu0XXdVDq7pMZxBrxDafCGIb01
	tab6qWyGkGtkWoKASeRZuxfmdGQ0R57TkmAt/Msh+5fqJLFxNa4+TCwGPiqD7TMh8fyW1Jq/p3N
	QGF5Kx/ro0BWnZIe2f0raPhzloRhzEE/n
X-Received: by 2002:a05:6102:6f06:b0:7c3:9059:49c2 with SMTP id ada2fe7eead31-7d50609f040mr768713137.22.1794411461945;
        Wed, 11 Nov 2026 07:37:41 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d3023aeac7sm3957545137.9.2026.11.11.07.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 07:37:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 10:37:40 -0500
Message-Id: <DMSHRWYSS8FJ.2H4W2E388G00V@soleen.com>
Cc: <linux-kselftest@vger.kernel.org>, <shuah@kernel.org>,
 <linux-mm@kvack.org>, <skhan@linuxfoundation.org>,
 <linux-doc@vger.kernel.org>, <vipinsh@google.com>,
 <linux-kernel@vger.kernel.org>, <corbet@lwn.net>, <dmatlack@google.com>,
 <kexec@lists.infradead.org>, <pratyush@kernel.org>,
 <rdunlap@infradead.org>, <graf@amazon.com>
Subject: Re: [PATCH v5 3/6] liveupdate: luo: serialize sessions via
 per-session publish helper
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport" <rppt@kernel.org>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-4-pasha.tatashin@soleen.com>
 <179439592040.425130.1571434550510654411.b4-review@b4>
In-Reply-To: <179439592040.425130.1571434550510654411.b4-review@b4>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13EE5180005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wo8kcb9eiu6yficjgg15ohsiomtnwzf5
X-Rspam-User: 
X-HE-Tag: 1794411462-911274
X-HE-Meta: U2FsdGVkX1/7TKKpI34BIQ41yvCoTEK1b5GYmaD8KXWsidzf/LBSGQuoa9k4Db5HVV78WP3+rCIkC6yFZC8ZX7FCepr6mqi9gGN1g52yZ0AHaPc3sy1gF10ugA/rkqu8v+FxGUtDOERfqzxTnKP8Atdrj0rractDtPabylLtoLCdv11r1DFyYCSLW1eaRV9NLBYDSDtjZNRzHXI3vgrn6i5DnJbbYKv41H2koO19bGTc0ikhXbgUx+qs4v6qpmsQsOSHoBDymviKYRUMG84QQC+jv2hLdJO2BxMQTOrRvJI/YPbJQHbQHbwxZyw4vCNn4iLln3WI5vpeIETQ0TcBYf6uci88ITgdDy5Y7J0CXtl6NFsR7ZQABR1tEY6uRc/6sbdqL52iHqOCm6SFqDdbVXEIDt66RJ+mExxOW9fbvd+tjvSnMD/RObzohsOm7+GojNxEiplm+V+rzcMLzLhHvKbKseuzAez5jHqL7/bE+nbBUh0YtlPyF2VYBNXiB7Bl82PBKvP5HfPy9zBmACElGtEYVUaIgZI+4TVimHmjLXRvNjvT4F9LFXQH2w1rZTygNIniTXXi+ETyr30V+U24dlavyU+GRkno0GelWx8EfRnhnYSd9H9VflvjP4rog9G066arrxmXlVJaBjRNQD3+ZPOKSbMHNWnvoy5vfOAf/ZDYOS3NKY6o2VmYDjqP5wZekem/0HYWyZQe4g+Gje9N8qj/FQXbA4FAPKGxtf6uN5zUt4o2vZiyJGEE25MOJ+LKxDR/XGaA57bgBCVSVMrCKm3UF2Xa2BsxH8csEbJCQj9pZzXHJIvZkswvxaBaSsTgjTKHzjvSWDmhdEYsTNd33nztkPUk+V4Ftx5V2O+s0KMG/F6WIP6KIb7sZhQt2YCro9R3p3/8C/Rwm4da0cR5LTbEwzLmYWzs1vYrjkLxSmlCiG76yAV6FuRNqd+vRiCxtjHGNBUVjEcxGrwWVsf
 bNq+htOQ
 9DSpd07s2xqrLDX3XGFS8kYcpOSv6jrAgHXrdnq/QokK2XPslbP32j9vkeu/Ubvs9K0eqCRZ95omJp3FD3aEfVJ70m9fNNybKCZ6Gp9XkqBITMHI1aNVP+2F6NaSoMDVZ0EWla1oev55PZluT9Ru3OTqx5u/3HO+dhUXvGDEmgizVRCzoK1M8+9y2CVK5NmtZiGeYRk8S8WduOLHpjKnVaaV5ptZ9AQZctxDDia0xgxHMQDwrvEoPe9uNIQ+84Mpcof9MHO9L2abZ+oz6e8jM0+WpMUxqWPiwuBP9hg378et6OB/bENbfMnxdQSUF0TSCOnO/xhRKmCKdxWkFgvB+/AeBtuI7BpmmS8O8kRMgfslzwY3qckSGzqOEaxq7gD/lbS25nKzn8WUYeRu3NfKaRFqQWwFzUvGyefuXvbrI1MgTFXNskMzQ9MnVObO9kDNHbQaokaL9z3JnYu79HdPGYEsbFd2C2t47xWrp5j6tgj86x9E2Vdi/u4uo1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 6:18 AM EST, Mike Rapoport wrote:
> Hi,
>
>> With incremental kho_block publication in place, LUO sessions can be
>> published into sh->block_set individually as they are committed, rather
>> than rebuilding the entire session serialization chain during reboot.
>>=20
>> Currently, luo_session_serialize() resets *sh->sessions_pa and
>> serializes all outgoing sessions from scratch in a single pass at reboot
>> time.
>>=20
>> Introduce luo_session_publish_one() to append a session's
>> luo_session_ser entry via kho_block_set_it_append() and move the session
>> onto sh->published_list. Update luo_session_serialize() to freeze all
>> remaining unpublished sessions first (rolling back via
>> luo_session_unfreeze_one() on failure) and then publish them in a second
>> pass.
>>=20
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  kernel/liveupdate/luo_session.c | 92 ++++++++++++++++++++++-----------
>>  1 file changed, 63 insertions(+), 29 deletions(-)
>>
>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_ses=
sion.c
>> index 6dea359111818..caf0e85081e87 100644
>> --- a/kernel/liveupdate/luo_session.c
>> +++ b/kernel/liveupdate/luo_session.c
>> @@ -103,20 +103,30 @@
>>  static DECLARE_RWSEM(luo_session_serialize_rwsem);
>>  /**
>>   * struct luo_session_header - Header struct for managing LUO sessions.
>> - * @count:       The number of sessions currently tracked in the @list.
>> + * @count:       The number of sessions currently tracked in the header=
.
>> + * @published_count: The number of outgoing sessions currently publishe=
d in
>> + *                   @block_set.
>>   * @list:        The head of the linked list of `struct luo_session` in=
stances.
>
> Add "yet unpublished" to the description?

Yeap, will clarify list holds yet-unserialized sessions.

>> + * @published_list:  The head of the linked list of published outgoing
>> + *                   sessions, ordered identically to their entries in
>> + *                   @block_set.
>>   * @rwsem:       A read-write semaphore providing synchronized access t=
o the
>>   *               session list and other fields in this structure.
>>   * @block_set:   The set of serialization blocks.
>> + * @it:          Iterator tracking the next slot in @block_set for outg=
oing
>> + *               session serialization.
>>   * @sessions_pa: Points to the location of sessions_pa within struct lu=
o_ser.
>>   * @active:      Set to true when first initialized. If previous kernel=
 did not
>>   *               send session data, active stays false for incoming.
>>   */
>>  struct luo_session_header {
>>  	long count;
>> +	long published_count;
>>  	struct list_head list;
>> +	struct list_head published_list;
>>  	struct rw_semaphore rwsem;
>>  	struct kho_block_set block_set;
>> +	struct kho_block_set_it it;
>>  	u64 *sessions_pa;
>>  	bool active;
>>  };
>> @@ -134,12 +144,14 @@ struct luo_session_global {
>>  static struct luo_session_global luo_session_global =3D {
>>  	.incoming =3D {
>>  		.list =3D LIST_HEAD_INIT(luo_session_global.incoming.list),
>> +		.published_list =3D LIST_HEAD_INIT(luo_session_global.incoming.publis=
hed_list),
>>  		.rwsem =3D __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
>>  		.block_set =3D KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_s=
et,
>>  						sizeof(struct luo_session_ser)),
>>  	},
>>  	.outgoing =3D {
>>  		.list =3D LIST_HEAD_INIT(luo_session_global.outgoing.list),
>> +		.published_list =3D LIST_HEAD_INIT(luo_session_global.outgoing.publis=
hed_list),
>>  		.rwsem =3D __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
>>  		.block_set =3D KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_s=
et,
>>  						sizeof(struct luo_session_ser)),
>> @@ -186,6 +198,10 @@ static int luo_session_insert(struct luo_session_he=
ader *sh,
>>  		if (!strncmp(it->name, session->name, sizeof(it->name)))
>>  			return -EEXIST;
>>  	}
>> +	list_for_each_entry(it, &sh->published_list, list) {
>> +		if (!strncmp(it->name, session->name, sizeof(it->name)))
>> +			return -EEXIST;
>> +	}
>> =20
>>  	/*
>>  	 * For outgoing we should make sure there is room in serialization arr=
ay
>> @@ -203,6 +219,42 @@ static int luo_session_insert(struct luo_session_he=
ader *sh,
>>  	return 0;
>>  }
>> =20
>> +static void luo_session_publish_one(struct luo_session *session)
>> +{
>> +	struct luo_session_header *sh =3D &luo_session_global.outgoing;
>> +	struct luo_session_ser entry =3D {};
>> +
>> +	lockdep_assert_held_write(&sh->rwsem);
>> +	lockdep_assert_held(&session->mutex);
>> +
>> +	if (!sh->active || !sh->sessions_pa)
>> +		return;
>> +
>> +	if (!sh->published_count)
>> +		kho_block_set_it_init(&sh->it, &sh->block_set);
>> +
>> +	strscpy(entry.name, session->name, sizeof(entry.name));
>> +	entry.file_set_ser.count =3D session->file_set.count;
>> +	entry.file_set_ser.files =3D
>> +		kho_block_set_head_pa(&session->file_set.block_set);
>> +
>> +	/* This should not fail normally as blocks were pre-allocated */
>> +	if (WARN_ON_ONCE(!kho_block_set_it_append(&sh->it, &entry)))
>> +		return;
>> +
>> +	if (!sh->published_count) {
>> +		/*
>> +		 * Ensure the first block header and entry are visible before
>> +		 * publishing sessions_pa to concurrent KHO readers.
>> +		 */
>> +		smp_store_release(sh->sessions_pa,
>> +				  kho_block_set_head_pa(&sh->block_set));
>> +	}
>
>
>> +
>> +	list_move_tail(&session->list, &sh->published_list);
>> +	sh->published_count++;
>> +}
>> +
>>  static void luo_session_remove(struct luo_session_header *sh,
>>  			       struct luo_session *session)
>>  {
>> @@ -636,50 +688,32 @@ int luo_session_deserialize(void)
>>  int luo_session_serialize(void)
>>  {
>>  	struct luo_session_header *sh =3D &luo_session_global.outgoing;
>> -	struct luo_session *session;
>> -	struct kho_block_set_it it;
>> +	struct luo_session *session, *tmp;
>>  	int err;
>> =20
>>  	down_write(&luo_session_serialize_rwsem);
>>  	down_write(&sh->rwsem);
>> -	*sh->sessions_pa =3D 0;
>> -
>> -	kho_block_set_it_init(&it, &sh->block_set);
>> =20
>>  	list_for_each_entry(session, &sh->list, list) {
>> -		struct luo_session_ser *ser =3D kho_block_set_it_reserve_entry(&it);
>> -
>> -		/* This should not fail normally as blocks were pre-allocated */
>> -		if (WARN_ON_ONCE(!ser)) {
>> -			err =3D -ENOSPC;
>> -			goto err_undo;
>> -		}
>> -
>>  		err =3D luo_session_freeze_one(session);
>>  		if (err) {
>> -			kho_block_set_it_prev(&it);
>> -			goto err_undo;
>> +			list_for_each_entry_continue_reverse(session, &sh->list, list)
>> +				luo_session_unfreeze_one(session);
>> +			goto err_unlock;
>
> Why goto err_ can do this?
> I really prefer to avoid error handling inside if (err) blocks whenever
> possible.

Makes sense, will move it.

>
>>  		}
>> +	}
>> =20
>> -		strscpy(ser->name, session->name, sizeof(ser->name));
>> -		ser->file_set_ser.count =3D session->file_set.count;
>> -		ser->file_set_ser.files =3D
>> -			kho_block_set_head_pa(&session->file_set.block_set);
>> +	list_for_each_entry_safe(session, tmp, &sh->list, list) {
>> +		mutex_lock(&session->mutex);
>> +		luo_session_publish_one(session);
>
> And running a loop of _publish() in _serialize() makes my bikeshedding
> argument stronger ;-)

+1, will fix it in v6.

--=20
Pasha


