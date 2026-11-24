Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB30606A337
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6LU+EVk
Received: by kanga.kvack.org (Postfix)
	id A0AA56B07CB; Tue, 24 Nov 2026 11:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2016B07CD; Tue, 24 Nov 2026 11:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F166B07CE; Tue, 24 Nov 2026 11:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA916B07CB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:56:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 083E4140C68
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:56:57 +0000 (UTC)
X-FDA: 85470617274.24.293D275
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C28480012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:56:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6LU+EVk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539415;
	b=dKRb8Pu9h6ZWIdkezcBOeFueRWKtoAk/v2rgn6HUi+9RfG0uiQHRMphXWk3SIR9NEzGiDO
	b/16i7TUAWONRT5P9UstF+YiP68i+s9IAwRZS/wLDfImewyTBa0/hU80iQ/AEBG5a5pyy+
	pTGomjh9raFwJfn+ldEyfnBbSE9b29E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQc8iAXrOWCo5dkpL4sta6QbqPzTZAceFHRxm6U10hQ=;
	b=x+QKi4sQKI++90zegc1+Vxe9PzqGoWVovcLeCuH6JoAgc/34/yD4zEVoMQNgNwZ5mP936M
	Qk0WCT4TqijKLi1/mRJZ8BnuJDK08FFooLtWxrncYbT2bgUyIwSTMjodgFrhjKkYp0Km9D
	Tf9wt9sTtNMYBEovnPDHGFcKKawSoHc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6LU+EVk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECA0C627BC;
	Tue, 24 Nov 2026 16:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1931F000CA;
	Tue, 24 Nov 2026 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795539413;
	bh=DQc8iAXrOWCo5dkpL4sta6QbqPzTZAceFHRxm6U10hQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=U6LU+EVkaQDm+64Z4ftbA66Y+KAU40+11CYgmER/NhuyjebuKqOtatstiSlFMbxvk
	 ru9xT3H0k1Gu+cMFsfPhFm+ActlHtUasCBeW+7Z7eL3bFiXpDJtFhPvHm5tQWfdsKy
	 FzaIyfukq7U7dBfP6JKM4YAIC6fBR/AcxaK+2iH4XYRR9bDch5ELsgeW5p3ZLCRVsd
	 +hGbnGmsGcJ05hItJZlSsz1pmQVi8rhf/7GXUY1ewWbnIL5sgo5MxoOa8YsIlBAvKv
	 Zmcj43Pn0m9Kd9zXIux0waf1D9EUhwqlW9KkBfbT9/ZWFAYd6e2NBd2rxuTgBJzZQ0
	 OnNU6BGRJGZFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <awWx1YnA0PcB2RaB@kernel.org> (Mike Rapoport's message of "Tue,
	24 Nov 2026 17:48:37 +0200")
References: <20261123130115.4021199-1-pratyush@kernel.org>
	<179546369651.425130.14155931836758567682.b4-review@b4>
	<2vxzo6bez3hs.fsf@kernel.org> <awWx1YnA0PcB2RaB@kernel.org>
Date: Tue, 24 Nov 2026 16:56:50 +0000
Message-ID: <2vxztsl6xj59.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 5C28480012
X-Stat-Signature: yd3uof7i481yu5xwpgrkd7nhcisrjoa4
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795539415-269159
X-HE-Meta: U2FsdGVkX18sN3F5H0G5A1hV79FUIs+A+SFAqXLR9p404er1v/8mDVhdLyAPaFLdD2NYgFM2UCUHeLYs1tjaaD97EVByrUU+0np2SzB0RiHLg7ee+itMyBjs48u/lzu2pmm6QbF7JpBpxRSLGAPsfQMEIHEw9SgUj/lCQUIBJm3NQP6ioSou9Ulju500Fs4PqJ+WVX/YNO/dKMIiodwGNDs6mmHAjyjkemzxg3cZrVU8oL1mzUVmKyvn0jAt88WsmCJLDLpJQ0dHMtWk+5GhsdAGbBgAO0AZNogqo7BnKRJoge3G6guS0e4X8XCUxDWDfhjl3HkvSKdBb8/IVyzjko1i6IN5DJ8LoHRR+F+1QdqKq+XdFQAl1Cu7PCzhfq4LxjBN7WnPm35aAV5QaiiqUYNCxQo+UNZTgoC2gXrG8OoQ5aJ+Q/uhe3aZ+bPIebw1enxY3RvEZf4YN+IdsNamh3YHlCly4v7DRLUc15/JuwjaAUoeRbcYasBsttM4FZWGjtOlD26HHKVMQ8BJfqyWXaLBz2DbNEPkQYPyNMpQNAofTmnBRhrgRVH1rdKkMM+/IP9UyRCWzOrcZgh66rArqlEw2ieSPbqa0cvA9RSlkR3GKSwRJ6kUFuH3BEJBcfsUlDExkYsaQLh/9BNlDzQn/RIDF1vi2Ob4rRI2pYrBkNIQ7YjvhwGI8Lt1xc/JO+iHPWBdqMV9Mn6+E64f8Mm34NAmnA6ylHuZCs1bNxc2qtQ+8RpgdBHnJYDpUdS6po5hRYl16HEx1bGRqGuu4LrOt4ARAUFkmJrB31q2/iSQN7KCxX9n5vQgdjjorzr9DLciwQTWQ/lvkNZYmcUDFEOja0qdSGr5GjXLi2BYMFxQny0//CMA2DQ7zACAEGAszhNjrOVOuzUq3hLoXU3gaQlfM125nRMtg/e9FZ8zA4UMorZZlYN/c7+teppnDdeEefmmDA8CevUfsN4awOBVOct
 cBTqIMq+
 4fnRWL3JO5S36uN+DGZrE3+jZM7+Y0J7mFpen5uaU/qxsLLUHna6IAR166sYRcHx1fpckOF3uAejID1tzUqaeTqJxXxlYWKghSZDfMuMiIdxYNMd031pQW3K6qP+8m7DSuoceJaSQeYfEzBQQDWobjrmsmEcAnab9ytdPN6MiB8i8C//CYZlmk1keAwp3Fgng1mNkCW9qovdw5FoB2eZCzruz4EXJR8x4roFZtlqdFZU2tn/aQ/ZkFa+pgUTCxycrRElufQq1No3ducP2RPBXu1xDtrSRN6wppItTIvHoR2KZzNVnw2wA8nEvMcY13WP/9QncTn2Z+Mq2yxtraSLmnFLy+U9qH7z5wQ69bjRA2GtZ7x0jQ2xQ3snvzTJLYLWHFIZ3uMsYEvCDInoaCblb5siClenNs96Rol5LkWgtx1LJlCxHCcs7SjTKp+Mj1p+70xAgVYBs3YbXRPe7gYPUHi78l8eNLaNbJZei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, Mike Rapoport wrote:

> On Tue, Nov 24, 2026 at 02:51:59PM +0000, Pratyush Yadav wrote:
>> On Mon, Nov 23 2026, Mike Rapoport wrote:
[...]
> v2 was better I think, but it still had that
>
> 		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
> 			continue;
> 		if (err)
> 			return err;
>
> which I don't really like.
>
> I came up with a variant below that IMHO makes things more explicit:
>
> static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> 			       struct folio **foliop)
> {
> 	int err, retries = 0;
> 	struct folio *folio;
>
> 	for (;;) {
> 		if (retries > MEMFD_LUO_MIGRATE_RETRIES)
> 			return -EBUSY;
>
> 		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> 		if (err)
> 			return err;
>
> 		if (likely(folio_is_longterm_pinnable(folio)))
> 			break;
>
> 		folio_unlock(folio);
> 		err = memfd_luo_migrate_folio(folio);
> 		if (err) {
> 			if (err != -EBUSY)
> 				return err;
> 			retries++;
> 		}
> 	}

This has a super theoretical corner case where the migration can
succeed, then the folio can migrate back to CMA by the time we do
shmem_get_folio(). So we can loop infinitely.

I think the if (retries > MEMFD_LUO_MIGRATE_RETRIES) should be after the
folio_is_longterm_pinnable() check and retries should increment after
every migration, not only failed ones.

Apart from that, your variant looks nicer.

Does that sound good?

>
> 	*foliop = folio;
> 	return 0;
> }
>
> It does an iteration more than v2 with the same MEMFD_LUO_MIGRATE_RETRIES,
> but that's not really important.
>
> Your call really, I can live with either of them.

-- 
Regards,
Pratyush Yadav

