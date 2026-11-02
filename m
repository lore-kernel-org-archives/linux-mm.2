Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A3360A2617
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MZz/KHXM
Received: by kanga.kvack.org (Postfix)
	id 08A786B05B1; Mon,  2 Nov 2026 08:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062FD6B05B2; Mon,  2 Nov 2026 08:02:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA2D6B05BF; Mon,  2 Nov 2026 08:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C84746B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:02:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01FD7A0C99
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:02:52 +0000 (UTC)
X-FDA: 85390193784.09.8D7D176
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC7CB40014
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:02:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MZz/KHXM";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rVghLVE5+gMoBZCIIvb0ZQoGty/hiEa5No/b+jM194=;
	b=EMbGPgeV539Cqy3L/C/zGVzIloh5iATV5TCDawStgvryjurPxhwX36A/kcb0LGtpN0QZ0Z
	DOqVfwASrSOlsS4UZWrZjg+q+pFCGTRqwIEFAyN27Jg8HkPEOJkHX4JcaXpn4egOUBgdG2
	fv4Kl8uYTRDgXTOYHCTpCCb77Pbcqyc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MZz/KHXM";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624570;
	b=zwdA6MMFA4WSjsWv9WZPu2tjTHvJemNnNiqVMEpr/wi57aceCz+C/cw8H/ZkD3YFLTfGl2
	RBRFH1wrFUSYAXvQsT8h9LW9N8Ln2l4nlSTZrlsFog2GTpejEW31CHhWOTbk4s98cUlOKP
	gh8C0GXWBIT8rp6JCibhBlV8cmjl/FQ=
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2e538951d07so29853325ad.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 05:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793624569; x=1794229369; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+rVghLVE5+gMoBZCIIvb0ZQoGty/hiEa5No/b+jM194=;
        b=MZz/KHXM5MTeC68Kkqg7PRloOIrq86bTe/FDIA5iUGRKR9hDOI7PC2ZFsQPV36BLp5
         15q7xDMK7WcvbSBvQ6xb+8G9nh2XDDAotiUmsoyPP091rQa3xUsLMCM8EKAgna/lv3+T
         viRIP5/VrrJwIaX0k0BAQAWRjNskqFuu4kYTD2XsrUTTHRX/nz+H89qdnBQXFrFU69s/
         RekSxWjweuZ/wS2NamLBFlYiROLo69aCji5nJBbV4k0SniYprxE4EXU6ApGzyOtsml5S
         an3QqkBTqPfwu7rR+fJF7qRF5ufuiJBNDjjS1YyF0eM7a3ZlqZZWtdGRjpM+mq3AuzMS
         KzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793624569; x=1794229369;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+rVghLVE5+gMoBZCIIvb0ZQoGty/hiEa5No/b+jM194=;
        b=F5GJ1RtSWPVnixHBuJAEs3sgvjPbzPlNalt1g4q0Sz51pV7KW163BUYfTT1Tu8AGta
         nPp23oFJqDNhhxmRvmuWw6M1uKF4mSofmeNNE6CrBl3JoLe41wMFYx169RHBkby59pYh
         0olXhSqK5Ikaj9cFCp49boexoIlQ4vBXQadLD8iCtPn8EKUjUwTNGr85MLzTTuVCjzvM
         CFP7ShCnIiW1ARDdDL0gvTf2/YHhj8bbta/K/qylkz4Bo9KMfTTYd9aCwxs30G8pdyCM
         WBBNL2/kVrWScyaCitup7lU7TQ60/0zKObTB/DeHLiENq5cZ9lVKzhqcHg4n96fCVy16
         CXXQ==
X-Forwarded-Encrypted: i=1; AKwUvByYmet/EAlmpHGluGoqEY3LrpLiGTh/pa2OZdKsy4mZxp+FOiFBnrcF0jILS3AYJV8JRW/RLqrIHQ==@kvack.org
X-Gm-Message-State: APuU4Z9LEC12YalSsrrBIl09YIAJqikx3+5mt/sJ6jqyvtIJTOG/A2Tt
	7PnFyO2jPlWLQiprGKvZe0TGhPafFx8UFs4gYcn4qj6CPSS36Gz+WiE8
X-Gm-Gg: AYBFou1hr2kMHvFv2vGK84HHwWKILacDSgXuMkeh417FKjCJQuIDlzytLIGxefZAgha
	6VMpWHcJe8tL2eCJwd/GzFBNXKfmwF6IxoO8vUNoZXTj1aPgGnBH13Wiv1E7g8uslksySRr2Kq1
	O+G4i41P+MhvbQux44xr/az5Ue4918CoEhkiiYo6hmtqL7Bwf52wESRrMDJHNPFDGqT0Fa7WVZI
	OO6a0bgT60U5cHYEGk0fg+JE3GkumN8uMJrDhq7HmbyibS5KI2pZAa/FhqxNiWtIKQRDqQicsqB
	E+V/EtV4ICE/YfgTYNws25tOXsnTe2f0f4YXmsf5tBTz7YOC7k4aprMf6isbTxalE77J1yojRCw
	R2KB/+KcneNmoPri1SrpXo77PO/Y5tWSAgNK1D3lVPEmqktSWbTn5sa0lGjOzWGFRNmNAN+NEBt
	j66ejPR7CLXF7f9S7IwuqD1pK+NLP2LdfwG6+0fMhu+ddRrLyl1z3Z/iqcfQAaMPI+9JTiLFr59
	EQmSKITi7SD9zSw1MnQgzbjXJRtEmnEZlRx4+0HvvmFbfqcE5GR2cF5JRw0CwE2rcPIXHuju1Vl
	vItwO+q+b8pII4uQsRgpLcXR4bOZvB6qvsRDPGEIMk0I+Zash2OXD4ONe5iH9WU9VJmU5j9F6Jx
	mo1XgHHslk4h89oSAgOhza9TgI070Nax1YE78Bm1IhSeeK5x/YGwmW6U=
X-Received: by 2002:a17:902:db01:b0:2e9:8b2f:3561 with SMTP id d9443c01a7336-2eb3650034amr96629035ad.54.1793624569079;
        Mon, 02 Nov 2026 05:02:49 -0800 (PST)
Received: from [10.131.7.109] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3922f5dasm27542985ad.25.2026.11.02.05.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:02:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: honor write requests for owned device-private
 pages
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 02 Nov 2026 23:23:28 +1100
Message-Id: <179362220860.2958105.9509793190720553695.b4-reply@b4>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Felix Kuehling <Felix.Kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org, 
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Jonathan Corbet <corbet@lwn.net>, Danilo Krummrich <dakr@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 dri-devel@lists.freedesktop.org, 
 Francois Dugast <francois.dugast@intel.com>, Christoph Hellwig <hch@lst.de>, 
 Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>, 
 Honglei Huang <honghuan@amd.com>, Jann Horn <jannh@google.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Leon Romanovsky <leon@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>, 
 Nico Pache <nico.pache@linux.dev>, nouveau@lists.freedesktop.org, 
 Pedro Falcato <pfalcato@suse.de>, Philip Yang <Philip.Yang@amd.com>, 
 Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev, Simona Vetter <simona@ffwll.ch>, 
 Shuah Khan <skhan@linuxfoundation.org>, Sunil Khatri <sunil.khatri@amd.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Vitaly Prosyak <vitaly.prosyak@amd.com>, Zi Yan <ziy@nvidia.com>
In-Reply-To: <179352350180.2.12918668886938034091.b4-reply@b4>
References: <179343062238.2.2773026701442863377@gmail.com>
 <sashiko-outbox-192310@kernel.org>
 <179352350180.2.12918668886938034091.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC7CB40014
X-Stat-Signature: 6hkkeuu1popoqfcp63tecq9g4f57wnxy
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793624570-437470
X-HE-Meta: U2FsdGVkX1/7k181LV7LtKdKEYgROG3aNVadiGZQ6qu7la/1uzgT4+uSfd9eZcyurAKAW5nXgsw6aAOmF9MN2fJfNHhtBAjJShYVzHsXmdk+913FoOH01CNSK4RoowbWKhHbxiU/NBUvHKX1NfY5/OL3vH5xBvPaYe3Zh9VKWBz91NVa9TpqKrAwxe1GpT9URCpAV0cy4LW8KZZOEcWrdmO9vJPW6CRBahveetVdxS5gfjKSfAoG99+UaI1hs0vKYvKZL/2WEQFZfJVhoI+bag9W1Gk7z4fGsmmt2RKCauXAveLKhDmmb3zmJPgnJFs8eC/lA3dwyncnj4q3TId/yg5B/DwYvd4i0GxrMeHudK4teTw07pURY4f1/Rc1Ij+YGUs+JdAPDidIVSZ8At0Fd4r94SQXLFAoWK01FhbvfexnxFYv339d2pv3U98+H9qtVL/I64Z+Ri6QRpf3tT1iT9KOWuOGJAayurcjsrQgfVx3JTAyFFADogM4c/eVIPS/2WS8/QjU4w+nFRAI/sxnWuFHCmIJZeczMiLKtzvLalGYBQsn+WNyLggAvogAnzxCpx9ms7aGqrDBcwbSp6F77tPbnD34oRhmv3cqLSXWdkwHn7OgkZgs11Z51hRAeEz/gfEp7VXl7eCG+N/E5iPQ8WlZXXti9PM1n5pRw2/goA3xnksGdC3RMvdEycq17W+WeZjZgBT1ByRhJ+xxSgO5YswK9fljSROPNKbYGQPJRRfjIcBFP/5XQseZK5OfepdM5aC0q/oBbT/7h5eOA/Sd189pXNyRJVuuQcnQ7VhlPjcWsParSUAe11yKHEJD+L+2+Uv11y/BG8qlFLD7iOkEpQS9noYmbDn0smoqP9RGfTgMp03SRwE1nMmOsKzvtSAeRpnqfPfr21oNJVKIUSLGsBMXe2EYvoCZwlbrRb8hkqu3JQ+mMZAgmfMwACKvCWOsT053lU2oburuMgjrLeF
 c1gaQmcN
 c9gDFeKyEAd09djz2NSj19op/++BFi66wn6ivoZbYlw/OWzk7cui+KXIufXv8RSZBPMIKg+wUFsCX3D0uXgmyrZqEKXLr+nKqg0hUhxywO8mR79phBrF/P7cbn5a+rClcq5xfI9IARzjUk9KP8Ik5HtGzKrp95hNtEKysINZGSd51P6RU10RyADnOiWdObNfn+WqwRNKiF5dcTvV2spIJ4IwkUHfIkIAHplLhDPHOH0SBHwrDajMmjstvb2sqA+IXK53Fns9sxkQLEqD5ktUZL4G25A3FPjphVa/knQFr/x2qlJbkmj9hvzi1PTi0iGLGH3//dWjfLrrcfv/MddoMiSNfEyZqKqvQvfacQpTkAVABm/FEuJZ/CXFC1+58atPJa9NFWIpcwshrYTQLHdvbqRrICN5yDzi6ojHxtexHlR4Ahr4upRHdJ3mVmrkXTDFReiMDYN62NgfsQjs2VITt1Hq6pmCD3qUgqkaG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

On Sun, 01 Nov 2026 19:58:21 +1100 Aveline Noir wrote:

> Oh, I missed that. I'll try to fix it.

While working on this, I found that the fix reaches well beyond
mm/hmm.c and would likely need rework in several subsystems, so I'd
like to hear your views before going further. v1 shouldn't be applied
as is.

amdkfd holds svms->lock and prange->migrate_mutex across
hmm_range_fault(), and svm_migrate_to_ram() needs both, so it can't
migrate the page for the validating task. Migrating under those locks
can deadlock, since do_swap_page() waits for the device page lock, which
a concurrent CPU fault can hold while waiting for svms->lock. From
reading the code, amdkfd also maps such read-only pages writable today,
as it takes GPU write permission from the VMA rather than from
HMM_PFN_WRITE, so GPU writes after fork() would be visible to the child.
I haven't been able to confirm this on hardware.

One option I tried is an opt-in HMM flag that returns -EDEADLK and the
page address instead of faulting, so amdkfd can drop its locks, fault
the page and validate again. It works with test_hmm, but the amdkfd
side grew to about 550 lines across the GPU fault handler, the restore
worker and svm_range_set_attr(), and is only compile-tested. Read-only
entries also come from NUMA hinting scans and mprotect(), so pages that
aren't shared would be moved out of VRAM too, and Xe and nouveau would
see their pages migrated in the same cases.

Would you prefer an opt-in interface like this, a change to the amdkfd
locking so that migrate_to_ram() can run during validation, or
something else? I can post the amdkfd part as an RFC if that helps.

I also found a few smaller related issues, and I'll send fixes for them
separately.

Thanks,
Aveline Noir

