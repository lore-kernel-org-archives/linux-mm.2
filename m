Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BC9606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FiszYtIn
Received: by kanga.kvack.org (Postfix)
	id CBE936B05B1; Tue, 10 Nov 2026 19:09:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70736B05B2; Tue, 10 Nov 2026 19:09:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E4F6B05B3; Tue, 10 Nov 2026 19:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC766B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 085EBA75C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:09 +0000 (UTC)
X-FDA: 85420903218.26.6A0D468
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1348C2000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FiszYtIn;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794355747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejVE7bv+O6VL91N0JFJsoLHNOj9By5Og1w6pSTBM3gw=;
	b=ap2gyCBVrW5a71ZWU4ZgHw92cLRstoZqlj4lm6x2T2Zf4Y3lNeyJcU/vS8nbP8iCSKNZfu
	Pd7GPYeYgWIt8q46O7soowi2JpW2eLfeOkxlU++Q2+3k/IfjB6wuAIUXgz2mZMWGz5hUPh
	z8u/DDvaQqxz70pccNWOqqhYYHpGAKg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FiszYtIn;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794355747;
	b=6SS0/+ZBmZzuKAhcHdElnjUymPFDGUzcT2Zu3iSUDMejq9KoFXDZLk0HVUxnMToSPVdylQ
	P6YlyKZmusyOtNNEpEjQ6IZYHiOcnaftZ17K7Ggr2tBY78kzF/aLV1PngARqwQ4MZJrJ+i
	CLiv/geDfU2CIUOcK7SKg4MGTE2UioE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so15909635e9.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:09:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794355745; cv=none;
        d=google.com; s=arc-20260327;
        b=LM/y79zsuv7F0xtDCbhtN1UsXKL/Xf/n1BJjejamFbi5HR2uugSv4n1jXgOqgKPm/S
         Pe30T2fOYeSaBQsiL5HXTF0Fk1uay7ASiTCCcH6StoblSHzURhsYNjxITNZIu7Xdszqk
         d6giUNJcUE3f/L776mppHpxPI9IOC4pnmTBfsOGGBQcFAKygjPnw1ohczFqHti2zwBF+
         mFLC1WLMIKm7oogTVDaitfMaxXcS95L8zX8IoadviIiWJnc0jbvjHEpUC+oOoiI3QTfP
         4qCBTqA9Qmhzg/hirtF4XZREztCmzKFsXCbUNyCYtj2M75F8Bbkg2xUutTVuhkHeDfST
         E+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ejVE7bv+O6VL91N0JFJsoLHNOj9By5Og1w6pSTBM3gw=;
        fh=yQ75qCaYX7eIuDnQ4rPdFxFyg90ubeQ5x9uPq2pQqa4=;
        b=HX63/ub4+HJPbhzD+bEoSvwIIc4QDGe/1R7uF13Ok8JWDkcKA8gVMIqElN4PEtqU0q
         NIvVs3kJ3WkbycJS2QtWzNuxZiJvHsHvByC63IrIYYfOTirXhe1LNdHVeL6MCEr14Sss
         6UjeBKAMNS73isFVjkASupb9dq+23KmhnHseK+Q70CkiEfg1eJAZfoXPWYW5buKKwvvU
         OFORf2VXwzy3m8vOu2Py5Mmrot+tvjMNPWoxMlqZjdsqB+6X/oez9v7TY9PAyWRSN/TW
         KDiBUywohTaUo+IpYUwC7TpzW+lOk4k0JezyTHWNbuqSdy5OcO1dEbNSP2JRCOmEkf0w
         /IhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794355745; x=1794960545; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ejVE7bv+O6VL91N0JFJsoLHNOj9By5Og1w6pSTBM3gw=;
        b=FiszYtInBaY+4bCkyE/+ApZVLm/yxHgtfzKmMp+CrmMj3v1d9TuteEGTVDnvTLrBD2
         Bvr6zBqFptkTDaH0va/NDVMxlhiOUxYhqVxw7/15HfwtFpmJ0s+Vb25TRohQ12QxFEIe
         q4aRe4C0+rlW8kXyc8Ce+iESRkPKnpNqbmUpQHyn4KNHSLVreOrMmfufvdPMlX+twVvF
         nqvCeIMqrWFed6aSCF4JuJiBbXAz7WWBTBngHXcdyoumU4q+6/qSpztMjURF/qJIv86S
         aQknmVmfuRivC5sVxDVT52u2dYb5Jqiy1KBBfqMu5FAOBY8SKGTHDOkY8PpIZFh0vj/6
         mMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794355745; x=1794960545;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejVE7bv+O6VL91N0JFJsoLHNOj9By5Og1w6pSTBM3gw=;
        b=OFzXY4AqqMLGidVrJhwcB88xPgproeYxg0YTltamPipQY3F7G79pyZP9/XXLtcpxYI
         nJVKBv2mnXv05J48LdAVmezLWcqHTNPu7LGJ3dusn7rHWE51ygE2eITgU1cuk9DcZDxr
         JKZOI7w6Pv+j42wfrVKMcG14vtqdz5rYZ/TD2UJBIAqMHcxzEjhb0dbg2LmlCUmgzaSm
         lfKEnEijOra0DY0n7SeHQKrmNHQh5MAncWB5GJWdL8epR5oQ8DO1ktqCYJ+KEeHmrySM
         lUmUFvizvML0w8NMp1EJDmx114aidnps/56epum+J2hbkdvqz+jAiOn/tqmIIKc8ZqTQ
         keyg==
X-Forwarded-Encrypted: i=1; AL+hErEs9McMDymPGG+Hb0fc9umg8brTuzOmbLeTLB9V2F5IAuU4ZrQZwN7GHoODkFvl36O6b4LeKX2HCg==@kvack.org
X-Gm-Message-State: APuU4Z9jdJqmNR5QLC2yDFS01pyzENVs6pJO+zeoq+5drsARUXKs0g4X
	82IsLfVslEN8mFfmXYiTrNqXeY+crUev7SFS43sEu1ftmwJ+40R5gR8NtEyoImmlI5mDtifzTv7
	GpEeXjvm7R1uWlbbWJlRYypLFpRKZRXk=
X-Gm-Gg: AYBFou1/5ekYOnjJf8p1Z28mWOPeRWBPqBJwqT3/dIo4QAgMmZr6J7+y84x7kNoHxS8
	ETGPEMtdqg/yWbsUBMNIuDmTCNSJ6uFZtK285TJmKK/JFl3tlFzwGkZ/HFjKm5RJN5vbk7B6/Up
	ZzZRIQXIpNW9dGprBY6Oh2o0Bi2bPIk7YUz7iKYji5i88+qAuYZ3QE49u1Oim6JmCtKOvXUwdf9
	0sfPcuEpfCkHBO1okIGiHNd2nz+360R2BhlEotItDzHZw3mPA5ec2VFiXuNZ7wxCKEKY6nA/HPn
	SM1z2zsq/HIx8+uM2p6e//A8Jne8zSHZLLwxcS7+UqYG2z1T73WOYtU43AtRo1RAZVX67m1ep1A
	GbyIxF27+QMRPZyPvA8My+q9jUQ4wYKgBla8t04M4wGRCzGZ8ffSOGVlpYJsoTKaoBjcWJpbotb
	hQoRQVZ/XZZKFroZDLZBw=
X-Received: by 2002:a05:600c:4883:b0:4a1:d45a:3ae9 with SMTP id
 5b1f17b1804b1-4ba08e1775cmr9777125e9.15.1794355745545; Tue, 10 Nov 2026
 16:09:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
In-Reply-To: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Nov 2026 16:08:53 -0800
X-Gm-Features: AclHuK_RO65Q781zBaAcWpIFEOI4qG6DgWehJFHz4qnMtFOJAAdAQXrDnpqCAyE
Message-ID: <CAJnrk1ZkhvyGLUyZrf_gA3XBv1XTfHArGOMgqr=5XbSCBJHz4Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Kinsey Ho <kinseyho@google.com>, Wei Xu <weixugc@google.com>, 
	Bharata B Rao <bharata@amd.com>, David Rientjes <rientjes@google.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1348C2000D
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: tdzd77ntkhj5s1far3r8tf4ofyz87h3y
X-HE-Tag: 1794355746-513903
X-HE-Meta: U2FsdGVkX18rCmyDpZFcUiOHWOI4HmLS8R49ATmGde7WrZCTY+AEQno1kgy1qs6oQElq/HizW66I4oV2GhBToWsCtcmLJIJXe1WhGT9QGfetXMXBujLCJVo8QKIlwn87AIQAI5pfWqc08jJoO3r7LZTx43sCy8rIrIg9XuBNv9KDSasA+2uhYTn1aEAiUUpo2gkQQYmIgWvgO+nPYsYaZ8KLVgW3HRG8oA8l3Nio5ZTp1jSeOb2yjj0i5wYL/09DhjtTV2FZBfNFSgpYQFQMlLAmXuumzkQ7G62yvPQRV5+z3rnUYUNjZhVl4ZUpXt79aNFcmv3yKwqXZCRbcMVxkBbTUBz/3Z4AieYQtgAIzeIFPNuZdqKN3gbqeX55tdScGab1/2cTVskrckKy6COFDcUhE/db02mzSvIuTvTdvFHLtoHBAckY/+NyYdh35MPEy+0r5UFYaFJLR9j2By3UpTMKAw+rLmOM1TqxTExkF75rMQ5DQEeukcaePusK0Wjy7jHG/XJjA3wt/mrUFsVbvfFMHwNSSmsDjrePmw45niVaBF7sTcmwjvrSJRNA3HyyztzToGsl26MN4MnWMV76IFLb1K3fWZteRbRKKyRkekJMv8A7ZnFKCZ5WdkEbxZCrQEM1s8mlcneumToMMFRP/TY1ieuc9turkRjhvVPGRRN9BU3wfM262oOCZd9yMMzeJJplLs5pRgBkalbXtK9w+6BB2DC5dM6oASNERbFb8vUfhUSf4s2loSUsGAQMa3ELHoHTz64mlqr7/3KwD+fNtJ6uWIcYGsKofK8gLY06JD2/OLK3t95qt0s1Nvk8dNwaANggFX5zYnbCh07Y6oHd1tFFfJiXpiWvoDckIyjDrU72H+eMdPSxB0uT1I27TVALy01Qr2/C7Wv30pBxjJPiSSQzkqT949xcxamaDjwZyDQrNPI0fbTeecpY3h4w5kqpS+U297t/1rf2JutaUgr
 85GLmwdb
 9MsSWhPLCcX+OzSxBG2HezxQEZsignYT+bflmClofO4yYgZsabHOJnAXtJtFjWnaeBKtzmmH+kbS7Y6y57YPWCZcgreaSjpWUwVrPgXpqRepNhjs2KxpgRgIOyxau3fHaYaL5oqnaiyDzwwqAvtS7fmELwzmcm7QblN3ATgbjVoIS+L9tB5gqq9MHtjjWUglq2LOuhGs2oA6dgzmBIv7qUnEtAQUhqjf23ckfGdWTTyLXMu6bsWwiGLK2m2J7SfsmKZyoYWzxYtYfIzdlQRXtwbU0PNqRgc8/5qb9e4VWT+rEyetnhnd68Cg3w3xcBE9221aytcpsxhRWn3a5GMaiWR001VgJp8P8iiNtgzAHLABjwLZPV5YDk7dtzwtPtwrNNIS/xn+eVFlhpJ8NzZOV+5mOwU0hTEP5oLCc+LDHk/krhGKGg1Y5S8Oyp7VrHhEXr/hrXWqfHcGzCLh5DDFPAvKloMER5yC75WtGHU2clEIdG1RUNixBE+HoMXXxhG2ivB04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Aug 12, 2026 at 9:24=E2=80=AFPM Shivank Garg <shivankg@amd.com> wro=
te:
>
> Migrating a PTE-mapped large folio currently walks the folio's rmap
> one page at a time. It does so twice per migration:
> 1. try_to_migrate_one(): Replace present PTEs with migration entries
> 2. remove_migration_pte(): Restore migration entries to working PTEs.
>
> For a folio with N contiguous PTEs, each walk repeats page_vma_mapped_wal=
k()
> and the associated operation per subpage of the folio. (256 iterations
> for 1M folio).
>
> This series enables both walks to process a batch of consecutive PTEs
> that map the same large folio and do some refactoring and clean up on
> the way.
>
> Performance:
>
> AMD EPYC ZEN 3, 2-socket system (1 node per socket).
> move_pages() migrating 1 GB from node 0 -> node 1, throughput
> in GB/s:
>                        batch-         batch-restore
> folio     vanilla       restore-only   + unmap         restore%   restore=
+unmap%
> 4K        2.96=C2=B10.15     3.02=C2=B10.14      2.99=C2=B10.17         +=
2.2%    +1.0%
> 64K       5.99=C2=B10.10     6.12=C2=B10.08      7.65=C2=B10.16         +=
2.2%   +27.7%
> 256K      6.48=C2=B10.09     6.67=C2=B10.08      9.23=C2=B10.14         +=
2.9%   +42.4%
> 1M        6.76=C2=B10.10     6.98=C2=B10.10      9.74=C2=B10.19         +=
3.1%   +44.0%
> 2M       10.50=C2=B10.20    10.44=C2=B10.16     10.67=C2=B10.21         -=
0.5%    +1.6%
>
> In plain migration, the folio copy itself dominates the cost, so these rm=
ap walk
> savings are only partly visible end-to-end.
>
> When the folio copy is batched-copy and offloaded to DMA engine [1], the =
copy is
> no longer the bottleneck and rmap-walk batching translates into much larg=
er gains:
>
> This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
>
>                     batch-copy                      dcbm+restore
> folio    vanilla    -offload(dcbm)  dcbm+restore    +unmap          (rmap=
 batch impact)
> 4K       3.05=C2=B10.13   2.76=C2=B10.11       2.77=C2=B10.12        2.74=
=C2=B10.09
> 64K      5.85=C2=B10.11  10.66=C2=B10.27      11.56=C2=B11.45       17.55=
=C2=B10.56
> 256K     6.26=C2=B10.08  13.64=C2=B12.73      13.68=C2=B10.16       34.76=
=C2=B10.57       (2.54x)
> 1M       6.58=C2=B10.08  14.25=C2=B10.07      15.27=C2=B10.77       44.28=
=C2=B10.27       (3.11x)
> 2M      10.61=C2=B10.24  65.26=C2=B10.96      65.25=C2=B11.65       65.66=
=C2=B10.87
>

Hi Shivank,

Are you planning to send a v3 of this series? My reason for asking is
because batching the unmap also fixes an existing issue where when
try_to_migrate_one() unmaps a PTE-mapped anon mTHP one PTE at a time,
the folio looks partially mapped partway through and gets flagged for
deferred split. My mTHP underused shrinker series [1] makes this more
common since every underused mTHP split will now go through this path,
which makes this bug a blocker for the series. More context can be
found in [2], which was my attempt to fix this bug, but then David
suggested we fix it in a better way by batching, and Zi pointed me to
this series.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/20261103212004.1356327-1-joannelkoong@=
gmail.com/
[2] https://lore.kernel.org/linux-mm/20261109220958.2071687-1-joannelkoong@=
gmail.com/

