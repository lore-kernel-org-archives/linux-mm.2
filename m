Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CA8C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E236B00A6; Wed, 12 Aug 2026 05:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D9C6B00AE; Wed, 12 Aug 2026 05:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D1D6B00BC; Wed, 12 Aug 2026 05:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351A06B00A6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:30:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4973CA216F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:30:28 +0000 (UTC)
X-FDA: 85092096936.20.D590E74
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id A233514000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:30:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+KKG6z9;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fi1Sk4Bvje0wghFbC6BANw7VYtZF68SyZp7oYrXoxaI=;
	b=DWKKOvAfb2wWXXxd1ymEfZnYYErqs/KdW7fCFBrp29QcBrD/nFIDF1Y/nwKnjPRbct8vXD
	ImreO53oiNv34J+1IohK7bOH+gAJy5JkXqg8qdmbm0GhrPkRSKhDqCK4a5vnoMJDhYI6cs
	opopZmrov6Dw91X1NhCqo14kwQqMv1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527026;
	b=5o9fMlCY9bq3vMzhuqmaSEJcYEWerwNNGa09n61Sdma1LKZ16najpjhAXbf9WySjy7PKXi
	r9c+53wAkt0BRnwVUS8Xz7topn1egfy5R1kZU5brodKqE6CKquYTPiDyFFhU8+ckpJvxCa
	k6T+drnkp3p551/qTaGB8p4YMBxF3/c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K+KKG6z9;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5Hb81DX76S8IAtLPuaQ2fxU+mq3IGFWwbuaXDXn7mzM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786527020; v=1; x=1787131820;
 b=K+KKG6z9cIX9FtV4SGWxRFZtkclJ4Ip7BFSWS0p9EXL4lcbba2/pLfi2aZfUuk+5r3CDEm1j
 W6szvLRQ6EhL+a+giwTbBdWM3A40Qo2tyt/eFA104x0TxZSuEnJxPhsqGTe5Au2rrkD2koxtgFK
 /EtO5qN45kjk2sssO05EjFmU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 5cf300efea8cce09;
	Wed, 12 Aug 2026 09:30:20 +0000
X-Migadu-Scanner: mta11.migadu.com
Date: Wed, 12 Aug 2026 17:30:08 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <anw9ILJiO5xIjP4f@MiWiFi-R3L-srv>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
X-Rspam-User: 
X-Stat-Signature: oiocwzy8zforiaswiqkpxiygy3to6mkq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A233514000C
X-HE-Tag: 1786527024-427727
X-HE-Meta: U2FsdGVkX18+ca8aPLJAx4n0CIM8oh2+C36yHQngyLDOigW0esw9sThYInWx6PtY5GXFIB0Whvl7QlxBW1elScZnkix6SjM4p1ZLk9Z4pW0MxAZDmQYxMV6RkwrK5hgzhLX4T6BLKCsLUWMT5Imi0Lvzr90hDUpeCnt2dqf61fzdRJoU0HFh2/3W8Qin2lXG7vS1Sdu8XVExAg8zJkYjZgUx13FEWvLtobbz0EgNdlwkSzLMO9sJgfUXHvmy6zsC/t9l1IUNwmsGEKE+jJRscp6rKnVx6OMbRrqUVA/mM6qYP2YO1kZXtYZxwdX1mCUIxteVq/SmG8GFAdEXhujQx79YHy3Z3m7d4EVhf5iqyK06GXMFFOJ2amBmm8FNBnej7ullGFDtDs6/s1veyVOgQaUxs+SKMiL5aNATM3U5tmxZFk8naajwZ18Kuf7FS9QFAXq+JfiDiWYbREjLQqBTwZBwgQzti2zvNMXhxPC5RGFlfVuu2qZlgx/TusWD0aG72rFyV1xL7haB2mhsinpL3Ah+rXu/gZyaRFkQcPyABCtlFLBgUl8c96UBBtRyjHfJTLoNY90pPcC9YsRuRtu3HzuMkXy3m65C9edNpJbhdB4KFqE+1JSPXUp17080SlGR62rIAPO5x4PdaWZPouUfli8NeLFDruC1Xc+jghTAMMFzIWThNqN2pPp7bMLnmIEPdHVQEWN3Sf4Dy8892eGHXh+vM2uIZwqi1hrLmlV9z8TOrE1cEE1sK/7oxZv9HLQMREN8pzXeYz4+YW1LA6rbzQuM9Z/qN4E0dpT5j1LUtRC2rlUp7Ikh5DnzrIHan9xRZmwf36l07mxH3vHxJ/b/+6/QC3nkihAptXHLJ/qu57CWHV1EQ9RYCrsBVocQdqzs/zWZ++EsoGNicpqvpPbNobr5KF61g8SJBCKA9/Bf+Ej+h+7s8xYMBcEBDAqlyhOVD3vkl/NxnjWQzDrG/l6
 LtEINWFe
 SXc9grxlrYDS9rGRduTl0wJYWaFSzCUWwxA5ro8J9YN20LI6TV2yqbOpPXzFKLVPzqucQdJtkKZgf4j9TpdhkuxZ/rI+R3+0OlUZ3WNea6cJDn03l/zxebDnylsuPMk5+5D20YcIZCHZxe/LOhFeB8wxIQ5PElqoMugpLiiGnUg+jCJa/HDw6IY8Bs4cUfe4vRe1Tb+KUCvWMyliPnOSh92wXC4rYHfHVBlsDKKF1yCIApdC93lwAp8Knd9xwQew2f9ZtK0TO3/rmUavUfVGWeTvkeKE/M+yzjSg4zOyw3VRTt6lVzaF4y67Fud4VvHV1n94/Wsa6IIqrjS8Kk1rDyIqH+Cr4EmpR5RgPB9U9LFQSdj1UR+ZJDx4UANI6+h36CGWETPh2H0s/o/4g72dv+Nqi34k0GmXTEBWqFL1riXg9R7h315EEMrxfPLUym/1rSIC9PgRdmBAN53c47wMBJoHuJQRxqx8cAANH9tCwwkD5Sqck+vf8kbTW57rwP5SyN2BfD/S0LUgiwT4J4PqPHBp5WBCSvSim0KZM0i2EZiN4AXF1zNPrn/olvc7Pwux4lNlzDxAwyuNxiDupka6CRx0zY/Wpo34ARaUvfFT/triu1rKwPqFoU19oVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/11/26 at 07:52pm, Jan Sebastian Götte wrote:
.....snip...
> @@ -142,6 +170,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
>  			crash_cma_clear_pending_dma();
> +			crash_wipe_secrets();

I remember when crash_cma added this, we argued a lot about the risk,
finally it's added in with an added note to tell it's an opt-in feature
and risky. I don't know if it opens a Pandora box, I think anything
wanted being here need prove anything else has been tried, and the thing
is very very important. If we don't guard the door well, one day one guy
cold come and said I need ask Oracle database to do some transactions
before juming into kdump kernel because the actions will save billions
of dollar. 

And what does security people say about this wiping? Is it very
important information and wiping is mandotary? There's no any other way
to wipe it or pollute it, no way in kdump kernel? I noticed it's
happening on en embedded target, is it possible you do this on your
embedded kernel tree, but not mainline tree?

Anyone who wants to do thing like this, please prepare answers for them,
and be ready to accept failure.

Thanks
Baoquan

>  			machine_kexec(kexec_crash_image);
>  		}
>  		kexec_unlock();
> 
> -- 
> 2.53.0
> 

