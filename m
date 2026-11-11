Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EC7606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VRTKSDiY
Received: by kanga.kvack.org (Postfix)
	id BB8C36B05CD; Wed, 11 Nov 2026 06:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42B06B05CE; Wed, 11 Nov 2026 06:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A9B6B05CF; Wed, 11 Nov 2026 06:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75D5F6B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:18:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E597612025A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:18:57 +0000 (UTC)
X-FDA: 85422591114.29.CD21CB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4874C40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:18:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRTKSDiY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395936;
	b=4RyxGMNBs+KviLDrmKazN7kZUfo5VQUYn2pGck1Hcg6YF7uJljkiQK5Y6+UaRH7VIpVZTr
	FWUDD2A206OqPpdrgr4mB3AnKuc1pmaHhbMSu2IgGl/4BFp2RTPpOmhX4Utpuer/0eu04D
	mS7fzFaBWNfWZ24WxjPoT0/p5MqeKhk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRTKSDiY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9XWDjq0ioHgocmsF6DKb1AFT/UmRmoe7A2ABC70YKo=;
	b=qLRWjOBFUzfAvFrM1H32bZeTo6X9HTFILBkBR2QQwI27JKLek8eXliCS03w0j68bp0jo4C
	26fJtQ+82HisvR8yttmWJtqXkTJKPzzFeYdoSz5+sbv2qD29yMbsmbys7vdCabokrHsLOT
	8nX10pE9ali2VmFEdGCv3OZsS1eW7hs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D34936387E;
	Wed, 11 Nov 2026 11:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B3F1F00A06;
	Wed, 11 Nov 2026 11:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794395935;
	bh=T9XWDjq0ioHgocmsF6DKb1AFT/UmRmoe7A2ABC70YKo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VRTKSDiYZdByh6uiuUNwozMVTYOxfWNlBzOoBemFkGUBxVZpz45UtO87gSOGn3PGX
	 ghEmEWSVdkyuR1G/Gt+0EYjnd6HiUfcZjGAj4nKxgoOD5Z1QRH5y1LVXrpAbxi9aRA
	 NnjsYN4qgZhn0/zCduEaiGp7q3G99X5weN0ql0QsH36+BOyhTzgxpquwaQSaJ8Bj27
	 KSG03IFuB7Jd73YBLWR+keQoU5SqoIyUCCnWoZln8vehx79T0m5j0hCeKsSS6vRSHq
	 vTzGfcRM6onZM2U5/p8a82qZsFabQYEaG+llDxAbK0xygrVvePcXoUVEgLQN3nCwL3
	 yMsFtQ9R7DrZA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 3/6] liveupdate: luo: serialize sessions via
 per-session publish helper
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
 vipinsh@google.com, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261105050053.3063001-4-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-4-pasha.tatashin@soleen.com>
Date: Wed, 11 Nov 2026 13:18:40 +0200
Message-Id: <179439592040.425130.1571434550510654411.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4874C40003
X-Stat-Signature: d9h6u5dki8951iw1aznajbrx34d7mf41
X-Rspam-User: 
X-HE-Tag: 1794395936-226179
X-HE-Meta: U2FsdGVkX1/CWPFeHNG64C/SBifDr5FTffyDaObGOlwU7AKcXRueC8/93hZCW9YwLuivfGpEQzd+/veA/unBcWR9JvgwlpyDcbb5+GL8EDtOEi4NMk0F9drWEDSDt9IyPUc03WaFZqm6+fDQp2rTPrG3gXbq1czlIRNYQhS44+LvNW/WjoQgflal9ikaaj+i6bsV1k1EYwG+2Z76mq0YcYaUXXyaclAoytB8OX2bPm98v9fNnhKqwwKhTuzrT3Iml2VCmC1ZAZu3rOVNmEOrzrs0+tgT44QiioYeQODlovC8m9iHPoTDxY8B8EdWixAOfXBHTgHszxQNzt9ZRoSR88xRSS7+vVkxIhHEuoHlpKLGm47LqVu9viby/S+0pjsaz8RDvjiubklAXdyuP8RIHRguwlKd4D2njLi4VMb0RjWWAWkX+9DgbyoKZN9/QPW8RzkfahlTE9H/3nRC6tISx45uwoT7bYCHBplepSYRHTIItaC274sjERNoYHODSLChWTSE4Jqu/ZKg7N1D9vlY0FMMSfk+pwtE0F72j5JZjinQZzJ/VVeqSo/H+5acC9xbQVf6qutdcZbQQRVG9CSfJOOSF41QUQA9JpvtaLjfP+eFYuKYFL8bErkinU0YigLnruID1XlV1/OB1CM6WfHhHCTUyzHbSibunSJIt54zWMnJMzHgfXQjPITwi0+uskFlf65dNFjmMddB2o1gkM00eEJkLh593IBLCojSvi21qPWu5BWJEp3X635tFQfq9vgqP666MoPDMTq0W63qtYS2XD0nsKSi6lVryPbV7fym0C0RZUuuhUjbo/VbH3/4ZOxNR1xi6x9CUn6pNip/gXHTB19zd3AUMu56tuFThJvUmnuxB6dA2gAj+GOXu5hq7N3BkKYDGSTe/z+FAOhe0w4yv0baDk9jq1i6iDUGSE2EhlGrUwHhoHyF4GlFzDqkKdZ1nziWMmicld9lKlUqP3h
 CCGj9W7J
 QpacMaaJMPvddQZ3N99COcEJUhZlCrDzRbgmPHELVsieBnA1peoyryPSOmMUgO49LeABIXj3RG//tpkOIvn1RFvMiLj4Ju5ggg+T99s302uGHU/F71W1w+IZXH4rSuCHqS6UVFIN13kjtKQiZ2cu5g7iPL9qGrC6uHEcAeRf4UXSrPNttWNdaomk0NoOwRj8dDBrtBh6V6/1x/uN9quSHH9kutcp82rDFByInjYczyskF7reT68jn3S69nil42Q9yKbxhYYp5Mo393ZnsVsq3LmWw+BUTPb6OzjOJjUSAMYp2f6LAZ16m/Yx2ss2OTST8Qw4/SysX7johOTh9SCr7e7UCR/yC0BDGlYSZoj99Oz834N0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> With incremental kho_block publication in place, LUO sessions can be
> published into sh->block_set individually as they are committed, rather
> than rebuilding the entire session serialization chain during reboot.
> 
> Currently, luo_session_serialize() resets *sh->sessions_pa and
> serializes all outgoing sessions from scratch in a single pass at reboot
> time.
> 
> Introduce luo_session_publish_one() to append a session's
> luo_session_ser entry via kho_block_set_it_append() and move the session
> onto sh->published_list. Update luo_session_serialize() to freeze all
> remaining unpublished sessions first (rolling back via
> luo_session_unfreeze_one() on failure) and then publish them in a second
> pass.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_session.c | 92 ++++++++++++++++++++++-----------
>  1 file changed, 63 insertions(+), 29 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 6dea359111818..caf0e85081e87 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -103,20 +103,30 @@
>  static DECLARE_RWSEM(luo_session_serialize_rwsem);
>  /**
>   * struct luo_session_header - Header struct for managing LUO sessions.
> - * @count:       The number of sessions currently tracked in the @list.
> + * @count:       The number of sessions currently tracked in the header.
> + * @published_count: The number of outgoing sessions currently published in
> + *                   @block_set.
>   * @list:        The head of the linked list of `struct luo_session` instances.

Add "yet unpublished" to the description?

> + * @published_list:  The head of the linked list of published outgoing
> + *                   sessions, ordered identically to their entries in
> + *                   @block_set.
>   * @rwsem:       A read-write semaphore providing synchronized access to the
>   *               session list and other fields in this structure.
>   * @block_set:   The set of serialization blocks.
> + * @it:          Iterator tracking the next slot in @block_set for outgoing
> + *               session serialization.
>   * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
>   * @active:      Set to true when first initialized. If previous kernel did not
>   *               send session data, active stays false for incoming.
>   */
>  struct luo_session_header {
>  	long count;
> +	long published_count;
>  	struct list_head list;
> +	struct list_head published_list;
>  	struct rw_semaphore rwsem;
>  	struct kho_block_set block_set;
> +	struct kho_block_set_it it;
>  	u64 *sessions_pa;
>  	bool active;
>  };
> @@ -134,12 +144,14 @@ struct luo_session_global {
>  static struct luo_session_global luo_session_global = {
>  	.incoming = {
>  		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
> +		.published_list = LIST_HEAD_INIT(luo_session_global.incoming.published_list),
>  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
>  		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
>  						sizeof(struct luo_session_ser)),
>  	},
>  	.outgoing = {
>  		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
> +		.published_list = LIST_HEAD_INIT(luo_session_global.outgoing.published_list),
>  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
>  		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
>  						sizeof(struct luo_session_ser)),
> @@ -186,6 +198,10 @@ static int luo_session_insert(struct luo_session_header *sh,
>  		if (!strncmp(it->name, session->name, sizeof(it->name)))
>  			return -EEXIST;
>  	}
> +	list_for_each_entry(it, &sh->published_list, list) {
> +		if (!strncmp(it->name, session->name, sizeof(it->name)))
> +			return -EEXIST;
> +	}
>  
>  	/*
>  	 * For outgoing we should make sure there is room in serialization array
> @@ -203,6 +219,42 @@ static int luo_session_insert(struct luo_session_header *sh,
>  	return 0;
>  }
>  
> +static void luo_session_publish_one(struct luo_session *session)
> +{
> +	struct luo_session_header *sh = &luo_session_global.outgoing;
> +	struct luo_session_ser entry = {};
> +
> +	lockdep_assert_held_write(&sh->rwsem);
> +	lockdep_assert_held(&session->mutex);
> +
> +	if (!sh->active || !sh->sessions_pa)
> +		return;
> +
> +	if (!sh->published_count)
> +		kho_block_set_it_init(&sh->it, &sh->block_set);
> +
> +	strscpy(entry.name, session->name, sizeof(entry.name));
> +	entry.file_set_ser.count = session->file_set.count;
> +	entry.file_set_ser.files =
> +		kho_block_set_head_pa(&session->file_set.block_set);
> +
> +	/* This should not fail normally as blocks were pre-allocated */
> +	if (WARN_ON_ONCE(!kho_block_set_it_append(&sh->it, &entry)))
> +		return;
> +
> +	if (!sh->published_count) {
> +		/*
> +		 * Ensure the first block header and entry are visible before
> +		 * publishing sessions_pa to concurrent KHO readers.
> +		 */
> +		smp_store_release(sh->sessions_pa,
> +				  kho_block_set_head_pa(&sh->block_set));
> +	}


> +
> +	list_move_tail(&session->list, &sh->published_list);
> +	sh->published_count++;
> +}
> +
>  static void luo_session_remove(struct luo_session_header *sh,
>  			       struct luo_session *session)
>  {
> @@ -636,50 +688,32 @@ int luo_session_deserialize(void)
>  int luo_session_serialize(void)
>  {
>  	struct luo_session_header *sh = &luo_session_global.outgoing;
> -	struct luo_session *session;
> -	struct kho_block_set_it it;
> +	struct luo_session *session, *tmp;
>  	int err;
>  
>  	down_write(&luo_session_serialize_rwsem);
>  	down_write(&sh->rwsem);
> -	*sh->sessions_pa = 0;
> -
> -	kho_block_set_it_init(&it, &sh->block_set);
>  
>  	list_for_each_entry(session, &sh->list, list) {
> -		struct luo_session_ser *ser = kho_block_set_it_reserve_entry(&it);
> -
> -		/* This should not fail normally as blocks were pre-allocated */
> -		if (WARN_ON_ONCE(!ser)) {
> -			err = -ENOSPC;
> -			goto err_undo;
> -		}
> -
>  		err = luo_session_freeze_one(session);
>  		if (err) {
> -			kho_block_set_it_prev(&it);
> -			goto err_undo;
> +			list_for_each_entry_continue_reverse(session, &sh->list, list)
> +				luo_session_unfreeze_one(session);
> +			goto err_unlock;

Why goto err_ can do this?
I really prefer to avoid error handling inside if (err) blocks whenever
possible.

>  		}
> +	}
>  
> -		strscpy(ser->name, session->name, sizeof(ser->name));
> -		ser->file_set_ser.count = session->file_set.count;
> -		ser->file_set_ser.files =
> -			kho_block_set_head_pa(&session->file_set.block_set);
> +	list_for_each_entry_safe(session, tmp, &sh->list, list) {
> +		mutex_lock(&session->mutex);
> +		luo_session_publish_one(session);

And running a loop of _publish() in _serialize() makes my bikeshedding
argument stronger ;-)

-- 
Sincerely yours,
Mike.


