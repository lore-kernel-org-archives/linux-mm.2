Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E520DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B206B008A; Mon, 17 Aug 2026 04:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C056B00C2; Mon, 17 Aug 2026 04:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BE66B00C3; Mon, 17 Aug 2026 04:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81AE36B008A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:25:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D31A64071F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:25:31 +0000 (UTC)
X-FDA: 85110077262.28.E07EACE
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0117140004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:25:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LOyqKIP8;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786955130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NtS90fRAe355xukfFtCNj/3OysLrTWOHdxxnVUAgf0=;
	b=fQdqbT7r2Qp7894qRoqjd1kpMRKtHQP2j4S+IrkNsEZ9QrolSqBLy5OkJNLV6cUtGKUnee
	6/1eYOJV8MXaHFYGQqdsr9JLQ72IL5/TbhG1KbMQG5K1aNO+2JBi4IJpwfDes+dbCGeuBu
	P22aCtPktbsGexIBFpfV0EL4vr2zMjs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LOyqKIP8;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786955130;
	b=w4Ua3uwqzSNG91GYYGPRSuehrXDMBVfhyM0hqlWG29BP5aSfnv1HPLvHT1vaqN+P9wJ2LW
	LUDD3AyH35tH1e4uyf9+X7yL4buBeWwuDPVm6HMAWUpMRNMfS68hSU+nikI/sskpapARKn
	BJBtarmcKGnLQeHr83JHiOYyx6j3lto=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eYNadUi07A8AhvVYvTwlB5KEurgeLlJSPKo7wDdWLLE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786955128; v=1; x=1787559928;
 b=LOyqKIP8U/DmD1VoXOueW2cNHTUY3/mO+breI1tQhH1n/PEE4g8zlyymbMmdIYFnFcrv6RvC
 pVvzJcfFBnQDqpvY1sCEcQN/mBN9OQtSc2BU1Xz7W+DoGA3BCDQYWKOezSiLUw8E1W5e2I7LTZe
 wbwmY96SzDjJiffKJm3Ai8SM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 5d0fb72b720b7f63;
	Mon, 17 Aug 2026 08:25:17 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 16:25:14 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Lukas Wunner <lukas@wunner.de>,
	Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <contact@jaseg.de>
Cc: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-afs@lists.infradead.org, netdev@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/13] kexec: add CRASH_WIPE_SECRETS to wipe secrets
 before kdump
Message-ID: <aoLFai0gzzH2bGgy@MiWiFi-R3L-srv>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
 <anw9ILJiO5xIjP4f@MiWiFi-R3L-srv>
 <9765f7ea-36bb-4c7b-a19b-7facec97b762@jaseg.de>
 <aoGpcczo5GkBsPwt@wunner.de>
 <aoK6jXA-tF9qfKOZ@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoK6jXA-tF9qfKOZ@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0117140004
X-Stat-Signature: ehswnjsqk65gjqoa1nismds3i9rtzqip
X-Rspam-User: 
X-HE-Tag: 1786955129-644177
X-HE-Meta: U2FsdGVkX19U5/SV6a3L6JBuqBuubePn3r5oTzLG+oQTx2mZ7DkUg/crIxkorREmvrbqPbT9Lw4xsoehEFNU5mKKNsIJtXrTIV8VxXXH3PbXsp8D6/4CdFaWTfe8GUYzfe5hK4Ltx6m/jSzLJZEEQl31QbSaujK2fuEtHCb46M0PYV+nLzsq2x+Ci4owv5I627Pz+9tm3ewMUifSGIN+fWZuH0FTryFg2WGTngquTke3T1SCbiXLLLrH8ZHsH3pihKdRhDdFrWRF5h+jTmbRMujJLVKThT4D/6gYBqDEgJdX1I5vJssrEUjzsF8anFgSSN+RRQJZEKFPfI5QSvIF9V0A4qW6ZvKm90aravmsoE/aUx/6dEqJilwZl7KFqKAI1AVPg6EcU5nhqIqecveoqbBVUrgIEz4SWRlIx6kCZjgKkgzF0074hfwxceKVpLjdpsOeDJUC5+wHbyeZJn4SQzp8uB8oNnkE4M4FN/9WScrxKetOV+uDoHHs65uQ1FGP62crAhv3KXiA8gQz4VPXZ60dqIX6kjx1oWOb6k55lLe5D88kHRAmYFvqE4OMBt15ZXijXSt3HQTYRqC0J3U5ZlILdtyKcibq7vDBOozCLH+Kjy5CTFfGzKIB9YiqTrnoJZ5LOGCkm6MNYgfan4leD/DJQ6EWXYGBiXVkktAb5J56fCxVMS5SuwT00sS1M11WAWJEJMh7yOTDLSqA9TdtcwqlfsUqth8raMczFqo20Nkc38P7+rfkVITyM3bcu9CBqNBK6HdxiK1OLTIcsvfijWVJjPZ3pc6c4np96+nmGUhe19fm4jXla+w5bEsBVHpP4hGPKLk8fhBDw37Nc2AIeFvDPsuB+6QFklM8KDizfVQa234oCL6r4RY3JAk2kUQS2My5I75G366+XrpLQAWBWTM7TxT5rGHLFhWnXyQAO+upkSyVdBp6lH1hC/oHHl2Rw2kojdo8RGZlODGUPjq
 88R2LDjq
 Qyw0mxHboBWA3pvzjZRtcX6PZQrVq1w0/byHqD0ihz0UKhooRYqYluCEUtRHy69rMiNjfAt/jkz+TOU7XEaXAu8xY4gLm0lDeGWgvBxauh0b6EPeYGLHmeNgoZ/JVPK2AO8y+F0r4Ex4ulp0Ia9PPoMhBvUk/U0iJ4qd+i3PVT+mCQjP6/Dl0XqIBtAS5M7eJo0+OUb1OBkV26UvYFj5ef8t0n+xLTPRfPPzgzpRrAH3zY5no6OJ1pYPA3rC8MJd+DQCdEOjYcC50t9iekQZN8+kwn/YxMia2EnM/62A2h0WaoCaM3DjT/vPaEpvesmyQ0nQobc4MmLhER5j5MsEwZBOc/HD29J3PDlaxYXI7aS6p/Gc1LEFb5fuLkCVpJAJCbPWY98ROA2EYsRA+jwKZwF/pRE9iScoFaNdlUkNQyP5QWFUhgXV8yuhYgZW+FirRVoObd9FFV1OKmAi5+GY2bRuDQ5y9VlST5F+Q0W3jr2lSC3geJdZTpVlA6a7RaNXkDHfVvPaaYGrVTft+PFOo1MJz3jw/vOI98PNkNXRTDjz9/L95jCpxWOhNorRTRJ4YzAb9o03Fj2fJYgsOPjpHdJBP+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/17/26 at 03:38pm, Baoquan He wrote:
> On 08/16/26 at 02:13pm, Lukas Wunner wrote:
> > On Wed, Aug 12, 2026 at 12:08:39PM +0200, Jan Sebastian Götte wrote:
> > > I can imagine one alternative way to approach this, tell me what you think:
> > > Instead of registering wipe handlers that memzero places on panic, I could
> > > put an optional registry of (addr, len) descriptors into crashkernel memory
> > > that the original kernel populates with the PAs of buffers to clear ahead of
> > > time. Then the kdump kernel could do the actual memzero. This would remove
> > > all code from the actual kdump path here. The registry could be made
> > > per-core to avoid locks.

If this has to be done in kernel, your (addr, len) registry idea is a
better direction, and we can make it a bit more general.

Instead of a secrets-only wipe registry, consider a small "crash memory
region" table with an action per entry:

enum crash_region_action {
    CRASH_REG_WIPE,   /* memzero, then dump normally (leave zeros) */
    CRASH_REG_SKIP,   /* do not include in the vmcore at all */
};

struct crash_region {
    phys_addr_t addr;
    size_t      len;
    enum crash_region_action action;
};

void crash_reg_add(phys_addr_t addr, size_t len,
                   enum crash_region_action action);
void crash_reg_del(phys_addr_t addr, size_t len);

Two actions because the use cases differ:

- WIPE is what you need: zero the secret, 
- SKIP covers things people do not want in the dump at all
   — Registering as SKIP reduce dump size. I have been considering how
     to shrink vmcore size on some big system with huge memory, the
     vmcore size usually is several or tens of GB.

If this is OK to you, you can start a regiestry table
infrastructure with wiping secrets, we can add SKIP later and plus some
driver used memory.

I am not sure if it's satisfactory, but you can give it a shot to show
what it looks like.

Thanks
Baoquan

> 
> Since there are a lot of security expert in CC, I am wondering what's
> the risk if we wipe secrets during dumping. System is located in
> user's place, and vmcore is dumped and collected in user's place. If we
> filter out secrets memory when we dumping, what could be leaked out?
> 
> > 
> > Or create a dedicated mempool from which all sensitive data is allocated,
> > then call mempool_free_bulk() on kexec to poison everything in that pool?
> > 
> > Thanks,
> > 
> > Lukas

