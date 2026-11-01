Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D3E606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EZJ1bCVY
Received: by kanga.kvack.org (Postfix)
	id 97C176B00EF; Sun,  1 Nov 2026 08:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CD96B05B1; Sun,  1 Nov 2026 08:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D976B05B2; Sun,  1 Nov 2026 08:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63DDA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:08:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECB26C09BC
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:08:42 +0000 (UTC)
X-FDA: 85386579684.07.1CE32DC
Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1DCA92000F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:08:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EZJ1bCVY;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.2 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793538521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DN+73IopgojkHF5owDqrZcQJFph061u4C7fIX+4pVMM=;
	b=sNicghb0dQ9fhnVhPsz3np4XDp2llkzgli54dmEyHGueO6910UiaMD10BGrPCyK5n/d3jo
	t/al0o14NIb+nTcbfywcf9FUxvWYKe6k0GUH+npeGCW9iSOidR1/MdCMHmVwqRt+KiVuTi
	8boW5Rk4rV0OgoFgsCDJsnMZxrMjAfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EZJ1bCVY;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.2 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793538521;
	b=jN9/+QHM3CIHz3+Js5D8ikYmDA/jVVaSLeZGVBWmBuiZlJVszj3R/aW62wp+7a0Zyd6GRy
	sc2+krq90KESQntV+l2zdQ17QsUyCT4LJ/2UEQZXT7OVM49yYbRoiqyLRfga3tqTqGtuiJ
	PR2rYyXsptNTzk755X2tONgWvKPnoIc=
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso2158950eec.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 05:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793538520; x=1794143320; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DN+73IopgojkHF5owDqrZcQJFph061u4C7fIX+4pVMM=;
        b=EZJ1bCVY4LDHJWdZYWYCsGQRhxlluVqh8/cU7UprGWJ6kq/LQjlFF/qFNWd3fT57d5
         l8qv+mqmF61OzAHy+WQdlfxxxrSc1Kojf7L2SWFjVaNwo1t8fbR+oyarURjcdEO1rJ0j
         aLeqNKBKxrx3SHP2Egd/XEu6AxOK4aOFdvg7pkv/Av/mC9nwuUjtCoMohvKQjeTgUWkY
         T/9JNcZmFFc6id7gO/MwsNSpAWFPwwUQFobtbsfoxRHIBPv34lcM2lh8047iOuUtwWHG
         W/ax2wXkM3AGDDItJhb8/un9qNFUc0UPglIhgumTyS9DpRceAVDAR+YAFzmbu+NGTIlP
         TPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793538520; x=1794143320;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DN+73IopgojkHF5owDqrZcQJFph061u4C7fIX+4pVMM=;
        b=AydpMKt8obMdwr5C+Nls9ClocN02EWiEql1NrUIcAjQxoeGs+DJVnDbw4P98i8kfq5
         ganOKc4uk3RhFJKlbIV76veJVx+t8ULJxg0ZUiHuM+giIGh3vdWLGkJMX9YXV+ciQGWl
         HjC7fsMjebKn5BQltwX1CM+C1J6kUw4LqThWuqfqDEBjRB/ZCdHb0NiZZSKadvYAhsMr
         fk2ITEZW22biR0P4b3oY+f4GEeJvLh9RLsWJ5pXGNy3LCzYqEMWjbjTM/C8mBp/VT8Rg
         Ea2ezaV8rbszPyxSesCbCqi9nTVcX39VRwLa9u1R4PBcfzGgKqTLchDe6608PSfyD0Iw
         xs1g==
X-Forwarded-Encrypted: i=1; AKwUvBwTEGCMb7Tg/D1QSnLDxGETlKJ1z9eIWX3ftgrJtg7Fyit4o3dwoKi7bFL2HPNY5m/9jywFw5Fmxg==@kvack.org
X-Gm-Message-State: APuU4Z8QlCl/oSiPamGUxAZqjjXK+ZeBEhun8s9zqm87QwwTyzE30gB7
	azwQSaFjUEAPhsGEtIH94XjRnd1Bf0P2UOGarBi54owcz0GQtWtGpJVbboHNGnriWrKbE2Cx
X-Gm-Gg: AYBFou1OfrtTra6GAPDd/lkUsj2RTNvAuDWsMBAsAm8HkVdywk5A4ACDnGpwE+7VorV
	svTgIMpS5KVhOJndTsEGYnkwODvWqNIdn0KJkpn0+xW5k09b8DLRk1JVcM0mz+V43dgP/m8D+Qx
	qSBJSdN4lfLgo5xMtfiBU+MkHMwg+NFELFyVdrcx1iB5GuZJyrci0V0T7xO/sMpBlDBDn6KYoel
	N3J98S8dU7gL9AFYWegLtVnFuADCE1D6iw7neAyddsrJc4W9HrxoTt6JNJnkNgm/LLtycucuddL
	bIjfMIKRS+sLDl9xUz6iJ2uoLW51Ajy4LZltS6zdQyozzzFm9pvysIYdXf4Lubir00JtnGCia0o
	FBuCOFgr2/orlsTOGZq442yQn/8s3Uho1klRd/6KxtQ9KRS8QIKyDalvbmtL+I0KSZi3DBCVyPq
	vPUjLfaBmVd4nO6nWhBga5fxbgcfZArrZKsPxhA1JAU2tDC2v4zXCkKICTmShQlTSZ8LjX4XzX1
	VBvN8RBpXY53N3t0iKwkTuiodmoSQ8zRmFRk8AAb/QYeDtQK9sj2KbHgOGJSL7YtUmwFwSYJ2Z7
	T/r6MHFBQfJy3zptVD4Re1TV0Lvb85JzZZjYgr0LN1GK7DTmQj7QORNeKU5eoVe2XC6k+swoPaC
	nNm18J4amxHcXGytrznwDBNsZFIA=
X-Received: by 2002:a05:7301:da83:b0:366:83dd:46f3 with SMTP id 5a478bee46e88-36a423a1f05mr10839613eec.14.1793538519681;
        Sun, 01 Nov 2026 05:08:39 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4294419dsm25939660eec.18.2026.11.01.05.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 05:08:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] hugetlbfs: report inode limits without a memory
 subpool
From: Aveline Noir <jm5905938@gmail.com>
Date: Sun, 01 Nov 2026 23:58:16 +1100
Message-Id: <179353789680.2.16953097023348053073.b4-reply@b4>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
In-Reply-To: <20261101122653.53982-1-dennylin0707@gmail.com>
References: <20261101122653.53982-1-dennylin0707@gmail.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DCA92000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: djyi89qe6csei8xph8835t8idjdugzru
X-HE-Tag: 1793538520-880946
X-HE-Meta: U2FsdGVkX19zVHv1QcqGU8kfg3O8YVMrSZVVe4myw2At8Tyg2XFWPuTzxKGr14RUSSRvmI498OPcSKvk7T9tZPNBYSwJJUaotAcp3n80AP8r1t64kB8H5t5KwOEbY8SifZpaG/6aM1DCd/x6bO5p6XwnD0OotG8/jz8TDs+EKG66GvC+uRsE+eel00BBXl/h3LP7HdUDOVrJYYVVwhBpV9urgDEiEbXnntebSUjJ5HBDp6285caHBRfK7AJs6Qhy+vt1vtU9HNrFZpkyJZ7iBfk9xn7ZmJE3euDXYUeH3tImd8M8ls/n3zm9ZmEY1i5rgPJOfl1Mzf94asu3lfddiOPZT6r9SdzmzjmCLsnpP04avdXcdeB0KXvV4Sdgp9IrN4KHHggzYKnIMnI+kXQ7FrI73VLVoz8kI/wU3EcVLtDmMR3g1ZYH5Lzh957bz3ympJJvs+8UKBpxF2lRZ0pER4mrNNQqIXq1w0wpXvmCTEdGEfDlibZ92FJdB4Vfw9B7UHfPKOy6G01n46P9IHHnO+Be8Rtrb8HyEMBardFwMMbqaXXBOZrcVgsl59lKYY9S8yYNQpeHUWt44TP/kyLSWK5UqhELs3XBgoWJoaGVzKAl02LegaTVC06HTj+diXNAptQ7viKRetnD1uFCvJSVEYtQb9by9HNrWgAZzAx/1yOBwKftnRhDy3FEv3ePPnIzM2q/77QaP24f+CvORzPS+RyVptZ4jJTJavX/XoBCd+7kxrEUeCgERL4znIjDXlKG0IrRwgQRAk3CrvKMxluymomv8yybdGaxkNWRuiLmTiwibuqerG1grM1cxt1JOoOM9m84GkKdmKCv7AjJsl30FthXDOQq+iGPQsSXneEgZPOUHCOQg13EokGzflHCpBy7S7C+kRUR5WPTD4RBeXN+SmngFhWwoguUgGzozm0ru2J+maycbXrC2RFry/S/uRm+L0CYSZQNLwe5GK8N3WG
 J2fCQAdf
 /yFB0RN23G7pjxWjMJUVl8i++EK3NTcVcmKq0gVcijrTbB5t1VHNE2R0111ysN+HOCw7bpN9N8ruiYUWq0dDR+kTDwGSJxKynpAM1d3bLxXWJ6BHGqd3KGyw6uVkA+qL7MsT117GDXBZ+lk60juFv1HIssYZPiu8uHLcA7+MZOFxf7c1cfaASZPdMQSzuaeSGWLnB7aebkxZ62bM1w3rl+XTdtNyDbYbZ2eYvOOCKVPc4Vgvf2jype5RAJxjflUORp0SiqcmqckduJFqmh0PoUuvLhaJGq/F1NdQHWPNkw+I++vY8mXmYkjZpOLz78HSpc+SK/olK3bTv3dKkiW3tLXOJp53Xo4lecMLH8+Km4514988FDIJnI4guZE+fVCtsgSTuWlbEzQM9blpu9zUAYST6VBpC7vx6t/iNsGfGwh6Z0BQkIZPmZU+ByjpCjfyjHp3K2Sk34D3XgO7Isfh0D8tLzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hungyu,

On Sun, 01 Nov 2026 12:26:53 +0000 Hungyu Lin wrote:

> Report the inode counters when an inode limit is configured,
> independently of the memory subpool. Preserve the existing zero and -1
> results for unlimited inode counts.

Tested in an x86-64 QEMU/KVM guest and all checks passed.
Inode-only counts are fixed, and unlimited counts are unchanged.
Makes sense to me.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

