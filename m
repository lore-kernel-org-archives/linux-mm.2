Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661DE606D801
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EziUgwa2
Received: by kanga.kvack.org (Postfix)
	id 68BEF6B05B8; Fri,  6 Nov 2026 05:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6626F6B05C1; Fri,  6 Nov 2026 05:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5552B6B05C2; Fri,  6 Nov 2026 05:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30EE86B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:07:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB2AB1A0D2D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:07:02 +0000 (UTC)
X-FDA: 85404265884.06.82EE336
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB4B2A0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:07:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EziUgwa2;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS8HVyR4zbY3pfGi/Mj8Yz7yzAVziAm8n3+oqxcnzgc=;
	b=L29m18w/0BbIvRBRt8BY2vWa5XdSTYpTV4WNm+EOMnp+iJBUNtYMCdBU6++VydmMB3cQPt
	zmqLGlezWRUGL6X1zEGIGJiyhDRyw4OwzLoKZOYdWkx7uZR/ccuIb1X0AmrBQILgESmQ2k
	aUWrNnL6btTgFTOej41Xva48DY9P7fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959621;
	b=4vo9ZVkE47IZui8/3W7PXPPoBNMeQgJM2uudg/utcgcQxBrUHB6dBPOHxE5AcE7FHP6ETb
	D1OYUQEKyJ1JP9RuxAhV664gWq2lZ/wVhx44bDQqv9+cqjYvLBDu3uCdinzzx7Kc8Lqck/
	v4EyVKjuZjScOxAXhrykXDPxc3ELIjQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EziUgwa2;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RbNpr/gp/P3/FChdryWgHiDNE03PXpM0ZDpmAqvKnzE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959619; v=1; x=1794564419;
 b=EziUgwa2y6pX6lOUce9W+3Pcj4so/8hyEMAWywYesjK8x6xHOAX/A3zDdlSpe6i/qDPi0g8V
 QNh1T9foTRG6i+++DrYKw5bF27iENNmcG9PEKvCKss+gS3dYDWPFzg9K0E9L0zqjnAwhnYd68dG
 Lso2HTCdggWNVfngEUj4sCWc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7c33c397d809dcb;
	Fri, 06 Nov 2026 10:06:58 +0000
X-Mizu-Trace-ID: b7c33c397d809dcb
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: azpijr@gmail.com,
	david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	hannes@cmpxchg.org,
	songliubraving@fb.com,
	riel@surriel.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	joro@8bytes.org,
	robin.murphy@arm.com,
	steven.sistare@oracle.com,
	jhubbard@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
Date: Fri,  6 Nov 2026 18:06:45 +0800
Message-ID: <20261106100645.77296-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
References: <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 71zeq1e7dmw15cgqmy67ajcmxtdyqna3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AB4B2A0007
X-Rspam-User: 
X-HE-Tag: 1793959620-296057
X-HE-Meta: U2FsdGVkX18hYWXlKkyRQrgNfwwVomFrTF4nFPt5HpsY7Uu5THwCL5TS5sXXPN4HT5MtRf7T5tCJfRaHXXvJ8pPBMB4HnkfpmSxwwq5KHlHPVKbEmHU2xxUOreRvtQdqJxL8lEHDUtsIM/eB+gAYfgUUoidMyluVlQvBE2X0+cqepcKLBhmdpn34/eqXiJq+pLnbd8U+b5DZ/5AM+72XpyOfdKWYD2cOq2hWbDmImyVWW875hxwnbtndu6h6qKXuKPp++fuaQhu8VdKqJKTn7oz5p93HK+ZQnzzE4Y61wzeHqfLViG10yaSLQGY4Vd6+S3zJVLa993SfV1eFpvn4397iCRw9MXWfSobahCHubT6XdLiRo8wnsnwAN4Y4THzEYgJBx+w2sk+5FRLAy9XY4MYH5Ki9Z0qppJNcRKs90xiGt2LnZWZWnHc3tGk6w46IBRXr0BCj/QN8sIWgGwBZoU778KaLZNb4NFBKeJVmDitRIwm8JEpOlQhW2rbo+8KKVF/zecqymUPkCs08u594tqhgRyoAlhLbA+yJkxIUCdUn8cqXaoNF6czCZ9QEMO2H97/4pY83+xoXjGumb1TFh+U5JzdPIoc3uhxL7QnIn6juIbR37n9ZmSNaud3huzsQTYdg/bxZhx7+oEF3QcCzpMB/VGbHgiTlkLzciRjcUoGN/akV96D04+CI6+rydhm2h1ExVbPmwhqMofNG2vXvhGk9h8IV3WiBIUIMAKY/MmmyM5WCE++Y/oHC377es3UYzE4iHnn/bx/KRJ0HmpFVfklpyrh78mYXfyc7L1+KAbHW4Ca1faEjV4xFXwbgVAskOkpwvwR0L1LgZJ0AnM8POFicIPZvMhWPNpNiA4Ez45SFozu3QGLWGrPP7KZ4zm44jFEKHEdkpnSqDfGy/nfTKoTUhPKQ1szSB3dUevN2PJofS0FWnUy4bTQeNIh+/CKTBxT/f/ge5Kp93QHwBmM
 9VQQtvxU
 IDFRTMx+V2e0YoMTI1fooq/QRx7TV6/Yv7fehmr1aeF2vhFZpMWf34+z7BcfI9K3KlZSjDZBDpahe1fnqYQve+24kdGDPPRfS0CGBZHZ19z+Wv89VCFSDMYiWS3eK3YgewDYzHT42kvkpQxHV4uKzul8FWG2qAx2zeHNvk6eJVsHpiZz5cWLSp2S0ltp2DeQB89GYwEpb8XRkDl4D/9IqkpwkVK8iysgn+79qjxz6eBmAOReT81wbLgog4MBM8MhruxtCZCYtIslqomtPth0z30pMvilSBdrPtyenJaEOCAEsKwefW7+i0sOVLrxOK8aW1orE99J7MpdAxx6/KsRe84bBBYHhHQ2c+70TGqB9udBQO3wXrjfBZq4ppb2zbGxc3ipnP3kfumJPTncjeHi9NUGGl+wMb/rwEPr6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 06, 2026 at 10:42:17AM +0100, Jose A. Perez de Azpillaga wrote:
>On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
>> With large file folios, overflowing the folio mapcount and refcount
>> became possible. For anon folios it is currently not really an issue:
>> each large anon folio can only be mapped once into a process.
>> 
>> That's not really big news, but it's about time that we do something
>> about it because some modern technology might find ways to abuse it :)
>> 
>> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
>> refcounting"), however, file thp support was added later.
>> 
>> File folios can be mapped multiple times into the same process, allowing
>> for processes to hold many references to the same folio.
>> 
>> As a short-term solution, let's introduce two folio refcount limits:
>> one for ordinary consumers and one for admins. Leave some headroom
>> before the refcount goes negative, which we really don't want (having
>> the mapcount go negative is also not expected).
>> 
>> Start reporting SIGBUS if we run into limits. When restoring mappings
>> from migration entries, instead zap the pte/pmd entry. We allow for
>> slightly exceeding the limit to keep things simpler.
>> 
>> This is far from ideal, but better than all easy alternatives we can
>> backport comfortably. For now it fixes the big problem: letting
>> the refcount (+mapcount) go negative and cause trouble.
>> 
>> This is only a temporary fix, we'll follow up with something better.
>> 
>> While the refcount checks are not required for order 0 folios, let's
>> just add them for consistency: each folio_add_file_rmap*() and
>> folio_dup_file_rmap*() needs a prior check.
>in mm-new copy_huge_pmd() now does a folio_dup_file_rmap_pmd() at fork,
>since Konstantin's "mm/huge_memory: copy file THPs at fork like
>copy_present_ptes() does". doesn't that one need the check too?

Ah, good catch! My local tree didn't have Konstantin's series [1] yet. And
right, that path needs a check too I guess :)

[1] https://lore.kernel.org/all/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-2-c56d0d26f970@virtuozzo.com/

>
>the rest LGTM:
>
>Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>
>-- 
>cheers,
>jose a. p-a
>

