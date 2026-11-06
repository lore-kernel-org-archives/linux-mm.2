Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E8E606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=AZCwgCmd
Received: by kanga.kvack.org (Postfix)
	id 1B2806B05B2; Fri,  6 Nov 2026 14:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BBD6B05B3; Fri,  6 Nov 2026 14:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B506B05B4; Fri,  6 Nov 2026 14:49:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C68D56B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:49:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E7B31A01D5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:49:35 +0000 (UTC)
X-FDA: 85405733910.26.20B8998
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68B501C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:49:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=AZCwgCmd;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793994573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfckAU/Yd29uVy4cVx78aos11SmH7YOOmI0OtH69KLo=;
	b=xRBRsCZXI0HrskKwJhKNoXZJoxeH4ANxPaoiqmDFUGrad6vYwJ3lRHJS3zbKlLMcbOOk5z
	NmpyqTM0lr6zLNjSIUZkQxWfZKvHo1mc51oKelZO8VMg0gg2F9EJ/HULjMDH4Y3fNsulb3
	Swd8NVPPLosd5GmhBBDpy87ostHCVRQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=AZCwgCmd;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793994573;
	b=F73fobc5KYex1Zu6dzX0Q1dVAIT1v/8/sTcM7CCGP4PAYVfRlYfCgPdybc2oXm8EPNAUYE
	QMikmD3KpVp+Au8hUHa3J16jnD5zUHp9u8HyP3KZLJZxBkYQBN+9NfA1UHCZ+lYQlF97SP
	2IQMrIS2lOm0GNkataYtCBkYOPWGiao=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-533778ab0bdso11492541cf.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793994572; x=1794599372; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dfckAU/Yd29uVy4cVx78aos11SmH7YOOmI0OtH69KLo=;
        b=AZCwgCmdphpNhnsLwHj5XAd6IeTukFabZfxr5DtlXyZmbLPPhz6wgHD5GiavE8XSHK
         2Zp7S5o2DOeyL4KUpCP80BjXsIj9/JuTC9OsAcogozKLwo7dUdLADWxQqNXuxp8iUpb3
         hmfuQ58NZ2xAwBKH9tGxwqn62AhnPm1Wt9Eom4gdLL38w7FXmoo6S4Ky1RJJZQ9Mmgs8
         S2qeHbTJwAQ4dHqFElhfrrnoJnMcniTAw/QglerqMq9RxJoq9ot7teCfXZFRqq8tBY3R
         btp8WXHBXRT0N1c2EReW02MPmsmurhHnjLcjRsVx3JtX7bjv3Pb3g81a2z4SRAyzHGbg
         YZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793994572; x=1794599372;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dfckAU/Yd29uVy4cVx78aos11SmH7YOOmI0OtH69KLo=;
        b=UVw9R4Wg2cbDmxrOJ7HgcvglBRnJNRk3h8j07h23GBleLR48RWv8ywAuJkWvhuWPw7
         vbCHBEMovme+63Z2MziT7f9JjUnj2mH16jQF0kZBfklKsoekxdo7XZzrL3t57Xau/Dh4
         tlA/3H7gEWNoMGH1YQ2CoS95zkU+Hs3Loy3L2ZOxxqiX6UbavdVKmuZ2VUco0DuSQfhR
         YNPmoJyxfBU9QybVuU+OHR60hwCSl0R2i2cJ41RqEUDTq7a0ZZz+XFB+1/p5J9966xbs
         kK0/lRsAHkcuSSKZIJIlJ7sZq2QX+kZPbMk+085mCgxozV6xDb6rhXdUb1hfT81WDu/Y
         0acQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOYa0lAs1g+UJVaNJ6MoB6yMqcscNmqDTtxy9fj93b4+W5CPydhhlTI5hYyghhqUPJNoxU0phknw==@kvack.org
X-Gm-Message-State: APuU4Z+8vZzIfFw56tbowdMEhGegyXdMmB5GIJX6nLsiwHT72xVN4M2/
	cnFPVWsfzqRUS07d0HWocQGaP0y7uO32Dlxx51vDc0rvbmQFgaajGLgA4hh/ucrGM3o=
X-Gm-Gg: AYBFou34LjDv8pdcCJG6yeV2otkFB+Ok0P2123E9nsZINLRXmkxf8Hzhh09xaxwSoS1
	3pZyPiHSCQbSrdC1TCCg1AgBaYGMwjvbBlz44dp3YmayEfu0hKg65jwvFZWefHunqtiLx+qbpWl
	QN7I3tBNAZdreEDLwhhTPdOBoVfu9tl2PJPwlLr27QcNHkuAIe56M5rykKtKb0EhppVjZ9GgnTb
	xS5RPoSmDUq27ddqKCT82Bzbj0R4d8QpH/NV51bsHx75lJFuxTJSDNEQ11zihrZCcUip3U2yckc
	u16teHoRfSS1Ernr2VbbwjaaOgXA3WlOEUnKcEqPLldKNIbL6C+7Q2t0JRLWD+QX6GVbQumNg7S
	HcR4Zdg45RdVWiHDoLoF/Ag0l2oWdMCcLZW8IjHxZ1NSZmRgbw3zUwaMJyd0DvsXz3RszEnEcuE
	SOXXUR38jNnj5rH0s3jqnVG921uwy/XUIUlj5i560zFLwWa3+WEoQH78OEJV29ko6IkkYsxrX4n
	C2GE3DBuiISTmCgECWVYel0F/wvDqngEUZjsjDxMwF0Arp36vyvp3fC7wBGS0LPsHDcYWSdvRAz
	IN1lLL25dvOe/EwLEOlkC4/GYG4st9ozmRNUQ7G+ugjR0A==
X-Received: by 2002:ac8:5f50:0:b0:535:30a:76a8 with SMTP id d75a77b69052e-54e15a65d6dmr55048351cf.59.1793994572184;
        Fri, 06 Nov 2026 11:49:32 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e26839a40sm27617471cf.20.2026.11.06.11.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 11:49:31 -0800 (PST)
Date: Fri, 06 Nov 2026 19:49:30 +0000
Message-ID: <2ab3b9da1c31ecfb5880542efa6508c8.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Chris Mason <mason@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev
Subject: Re: [PATCH 0/5] mm: limit pagecache folio refcount
In-Reply-To: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68B501C0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: uhwh1hipcxtxc6b8xhkjzgpiuh14d3ub
X-HE-Tag: 1793994573-322434
X-HE-Meta: U2FsdGVkX19CxCRi0ZD46K0/+JaIWgdtmxzZBCDf7b4vrQo36VL0PkxsaOh9Syw7eZmhCIYkylpQXBz0Z/nctuKvzc0voCK16/9DX48kxrg3Ngxc9McooPIr6Ys/ztm7TEA3zPKMVOGzaEDXGGi6i7VZpElwDV4a97W94AJGW+4zsFntYy/c7CcU5+DBx53/nV+MYkhB0DhR4ZRhM4XCDOyBJoC8uVd/a3LNUB9zdU0pRZb49wAvLnTgArUyA1GBV3gmpIO+ujRXxMPwr4rOZ7OjgM9O/gs1ocYMMSjJ39FDWREu1JbseIMRv3JN339V4XB7QHjPOguAxsKdUSTyJzxT33Ey9GL3xVKGvInSyfZdf8AWxZN4FRcsq0a4GKnG9lVXrfJ2VJyJrAyxXhYrKyyGAGDcn6fh9zfr5yE8zjhzaVQTy/VRZ7NGUsszuEbO+7psO8JC8ZA3+QADFo8T2aTyyscqhiOKN3vdNF3aIx8EUsS6XNXD5hj8/lwwLMGSaoFCLcnerQbIRqvpsmtYm0ljsfN/nqckJ85yFQ4jvvbxAyMYjxDG3/w6cQvxJBko+KjqVSxc3A3wuVxYploW3JHB9Z9vR5Dy4vDG2XtwwiRUbUDdfAX1VAvdo43MM4PPPPAm5htIgcg++810iSWZmmwX7UBglFh1Bs/8wR3MQSagY482SoVnjW3paBZtD9sTLvtMrYwt1SGuCTy1gnQwPlbk2U/RnDNGrZb2bo9icOYlItdq2QwmDzBZIAAHfcG6VxX0VEdvlvoZ1d2qhGD+cMmTPw+PYRYoog+idU/vP2XAmkoUCYBhsVNeDmKOxDIoP6ppmZHcrIz45D9cY8EDm4R0ECmQtx/7HrpZDCyetAxykzSNjzXvK5LjOZ0rkwucPvK7uMMAV3o+RZjqyl3EyUfsxS5GTclBWTv+NkdXjo4BefgDGvBvV2A0JrKlW2KabX4LHz8wbdzNVCgWEtn
 kXtKzSLQ
 41u3S/biqCCy9mAhseMw2i1X8skyIIOC1bw2eEzoBEQx78KL5OztBNIaH7Bslx9m2byV2NEITaJQoJ/264aBC9Mk+zSDQn70plxTyvuTintfbzwVOkcv2DUXyMtLHYAxg4RDLFQunIq0y9e4tfCdk+56ppqZe+vNgDETThxSG3+8sKYEV6cuCKdBPTaxIav+GmMONT8PrvsNPAj3ARH9FWnvOrIh3ha+wlcwGrQqvsl3qIJmCgpRLvmse9lMzF4JgDtua8lRkGWMHIiHGctdlM+kg0+tkLqzVAlenk2eavuL0x5MWWLlMQKz6EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:10:09PM +0100, David Hildenbrand (Arm) wrote:
> Users can create a lot of folio references to pagecache folios, making
> it possible to overflow the refcount of large folios.

This is a summary of my Claude review of everything, minus what has
already been said on the thread.  The numbers are from a TCG guest with
the limits lowered to user 6000 and admin 9000.

1) Small folios, 1/5 and 5/5

On an order-0 folio one FOLL_PIN is worth GUP_PIN_COUNTING_BIAS
references, so about 2M pins reach the limit.  That used to make GUP
refuse more pins, now it is also SIGBUS on new faults and failing fork
and splice for everybody else.  6 io_uring registered buffers on one
order-0 shmem page (ref 6146) and another task gets SIGBUS mapping it.
Mappings alone can't get a small folio near the limit, so could the
mapping and splice sites skip small folios?

2) Migration, 1/5

remove_migration_pte() and remove_migration_pmd() check the limit for
whoever migrates, not for the owner of the mapping, and kcompactd always
gets the user limit.  With mappings in the admin reserve the next
migration drops whatever is over the user limit, in rmap walk order.

At ref 7681, move_pages(MPOL_MF_MOVE_ALL) without CAP_SYS_RESOURCE left
1682 of 7168 PTEs unrestored, including all 512 of an mlock()ed VMA, and
touching them again got SIGBUS for all 1682.  Could the restore check
against the admin limit only?

3) fork, 1/5

If the VMA is only copied because it has an anon rmap, the pagecache
PTEs could be left out to refault in the child, like copy_huge_pmd()
does, instead of failing the fork.  Only the VM_COPY_ON_FORK cases need
the error.

4) splice, 2/5

filemap_splice_read() fails where read() still works.  sendfile(), the
copy_file_range() fallback and overlayfs copy-up get -ENOMEM, and nfsd
turns it into nfserr_jukebox so the client retries for as long as the
folio stays at the limit.  Could do_splice_read() fall back to
copy_splice_read(), like it does for O_DIRECT and DAX?

backing_file_splice_read() runs capable() under ctx->cred.  overlayfs
lowers CAP_SYS_RESOURCE there, so root never gets the reserve, and fuse
passthrough uses the server's cred, so an unprivileged reader may.

5) Errors

The one condition comes out as SIGBUS, -ENOMEM, -EFAULT (tee, pipe to
pipe, MADV_POPULATE_READ, process_vm_readv), -EIO (/proc/pid/mem),
-EOVERFLOW (vm_insert_page) and -EINVAL (memfd_pin_folios,
fuse_dev_splice_write).  Nothing is logged or counted, so there is
nothing that points at the folio.

6) khugepaged, 1/5

try_collapse_pte_mapped_thp() clears the PTEs and drops their
references, and then do_set_pmd() can refuse, so the mapping is gone
although the collapse would have lowered the refcount.

7) Changelogs, comments, stable

- 3/5 doesn't say what goes wrong without it.  It is tagged for
  10ebac4f95e7 (v6.9) while 1, 2 and 5 go back to v4.8, so 6.6 and older
  get the limits without the flush, and it doesn't say why that is fine.
- 3/5 leaves the "queue is (now) full" comments in asm-generic/tlb.h and
  above __tlb_remove_folio_pages_size() stale.
- The ufolios_count fix in 4/5 doesn't depend on the rest of the series,
  so it could be its own patch for stable.
- 5/5 needs 1/5 and 4/5, which isn't stated for stable.
- After 5/5 the check is the only guard for pins on small folios, the
  kernel-doc calls it "mostly unnecessary" for them.  The comment in
  folio_maybe_dma_pinned() still describes the negative refcount scheme.

Thanks,

Josef

