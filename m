Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB69C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA07D6B0092; Tue, 11 Aug 2026 16:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C524B6B0093; Tue, 11 Aug 2026 16:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B5D6B00AB; Tue, 11 Aug 2026 16:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880FC6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:43:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 243091A0133
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:43:10 +0000 (UTC)
X-FDA: 85090163340.28.D54DCF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7990640008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:43:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXLgdApM;
	spf=pass (imf12.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmqgrBJxUvss5ev2qg4hR/y+Shhz4DNLrdh9R3vpGbM=;
	b=4SVv5FRA/eJCmA2LJv/ZjoTGuCKPtsRHfpNbvm4f5XpcGiJKB7z2mvi5DlFMddnZMvW0zc
	T+iXibOHSU9l7jVGB8uMVcSPVmHCcYtYlyGXpIJGBDcxthBBYDCIRl8uEOI4un3bFp2+da
	5OKA8JgobIu7nzTEX19lAiyvqnUp04w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480988;
	b=7zZWBrq/AM6/5Jh1fgjY3Z11ju9Qf+MfSWAXXooOlrB1oC2x8dxxiEwA4BGJ9e2djkwuTv
	YZN9lXJc9CdctI9u1cmJozftpMKjzY1w1OL11/qUv54FMryif3XVcdE7yvPwAoEESpi9SD
	DDPKNHB1KYA6MQ2X+gwBduPug+OvexY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXLgdApM;
	spf=pass (imf12.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1D11600AE;
	Tue, 11 Aug 2026 20:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049C71F000E9;
	Tue, 11 Aug 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786480986;
	bh=tmqgrBJxUvss5ev2qg4hR/y+Shhz4DNLrdh9R3vpGbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YXLgdApMQVjB8O5UsuRCftLgsXmP3cSJYvwGgrqZ6b+hB2edLW/uSBh3oj2DAKDLB
	 6IioToKp+fdIkMueq1I/JRHsiwugXBDmJ97vp4UxyiCAtTlbgjkSl4kj3fA2aKAij5
	 Qgg6Hbg7EYU+2aNCB4H6ya401I1ujfkQIF2fhblv0bLnVJ432LahjN1sFPCZeRdz14
	 Cw5oUW8a78hswG6XALU3IdgCkVcHjig6EUfeU9hkjUA2GGFHo2hnqTAj7OaCds1AU4
	 UNwXanpKaMexoPY5I1l0K/a0V8GThMm0LE5dEKAkZ0GBpRhjDX5FR/2e1tnXNyczMQ
	 ftS06T2V5gAHQ==
Date: Tue, 11 Aug 2026 13:41:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <contact@jaseg.de>
Cc: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
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
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
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
	Simon Horman <horms@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
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
Subject: Re: [PATCH v2 00/13] CRASH_WIPE_SECRETS: Wipe secrets before kdump
 (was: CRASH_ZEROIZE)
Message-ID: <20260811204101.GA1905@sol>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811182012.GB2895176@google.com>
 <d242ab53-a39e-421d-ac39-4bee49be6ac0@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d242ab53-a39e-421d-ac39-4bee49be6ac0@jaseg.de>
X-Rspam-User: 
X-Stat-Signature: 6ixkbwdg785m3eejo4pphbj7116hjeei
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7990640008
X-HE-Tag: 1786480988-42193
X-HE-Meta: U2FsdGVkX18Y+WiUnGUNi100sHZTVk+3mqMmXIx+ieHxJ+IHSXBkUxcSwWQcWKnIsPxfY11DM4xBpQu6g7907AH9EUA4C0YVKGwyAnxWaQjJX7fJk9g/aPtGVIQ6LzQ0uWY1Vx2AhowLDWKPRiLq4u60Am323iM9Ftv8YlpbZKikf15vZQwWjg56FKfjeDlZyILlZ60N6oMjuQ2zt6Azr2FgbuEOiFCweOqgFcYGybplARXjDILfKDK0Vuh0pm8e7VAZo1glbS9xffwPWn2kkezh6t7CQrfNXVqKVmPUw9FKG3MXE+kWQpeKVqYaEf0taUtHeMjy0zYhutWCeaoF0dE1XJZ+K0MHm242jz8GyONxwK/zAlZdZsrdC5jxuiXin7S+Q+YN1N0zgShA8pRojbduceTpbO7+OETJ6lmYcdkPBM7XFXUqoyasylUtdTGV7P9oAv+5p7mHP5/xGOm4eODVlE+PosCHUqZZFv8PRi5RNzOKoCDcctBD4jV7U5zPOpsj3kEukW51nkTeOC76UgRBrueWbn4196l6Wo3gOrCHqIOtP2FpmHC8VIYKAO19hWYED9vfzBJCBVjPv9zLIlcVOtgHCKK8eDN+f1nb2NaybGOqbrwsbai5ZiqZs6RZCPZqlEiLrNtPHmLgyGDA9/z/snC7039qWrNEnZwh2Do1wrOp7mNXYMcGFGtY+6A1fN8k8o3Ibe91dyZRa6hUH5l0kYslmohWKwZgPfDvI6OBY/A7uPttZBNdmvXiweiV8lyqRUCKbfqB+++JodQO43M286IIZHs5I+46vt8Upuse9gBUv0dZoFEBB+Ki5X7dc8LgC5YWLqUj6ZaEIbSB0TZZAO5CbBpSxiwZrDX6SK1aeVlgV1ATLiWFgKH0RFCbcf7tuBZf5JhvDzoyF+IrNQruOESfCCR0GdylL6DuxvxnifG5lD57PKLhNaBz2fmf0xEFpju+7L6HFnqFcAI
 HrXUGZvE
 m6ewNrKlz0MzQAjqLIIRT8/juS/Pmd2aVpF1TgYfB0vQQWRBfnzGB4XbO0stXCauQIC34dmxET/PM80aM7PfJFa+ZoIFD1yIGb+W8PO1CUzMEl/oLafZVw8nuaUoqJMZRv0k5iXZhfN1kCDJQ+/T3svxb8ZIHBeVM4rzfc8/ZFU8BYMSq7lqRjvAFJHuWHLUgNEXNHQWltOSr0q6RkbLWApc7nXfmUkslJ7xe+Ewj3ty7mb85VybgNTdDR6/IXDvAq+xro+sqaaojDrFI13BvH5ISzrF0ju0lmvTVYk6BohdREYj5CTFKRfNFH0Z4OVf/mzVSQ+SEdja0pjUTKFxsrGZJkKWtGR8XkLsnGVmOSf+pv7txPdm8Qia8RcdESI6MyCZ3PZKXbnAUejs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 09:38:20PM +0200, Jan Sebastian Götte wrote:
> > Could you perhaps narrow the scope to one or two things that actually
> > are useful and can reasonably be supported for the application?  For
> > example, secretmem seems to be the only thing you mentioned that you're
> > actually planning to use.
> 
> I'm open to whittling down the scope of this series. In my use case I need
> at least secretmem as well as dm-crypt, which then pulls in the crypto tfm
> stuff. Personally, I could live without the other bits, I just thought
> they'd be easy enough to include.

Please do reduce the scope.

Note that even if dm-crypt is in scope, "crypto: api - wipe tfm contexts
before kdump" is neither required nor sufficient.  For one, dm-crypt has
its own copy of the key.  The wiping should be done by the kernel
feature(s) that need it, as they know what actually needs to be wiped,
and they can do so without the bottleneck of a new global list.

- Eric

