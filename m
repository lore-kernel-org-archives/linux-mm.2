Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58D060A2601
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TowH9GIZ
Received: by kanga.kvack.org (Postfix)
	id 07ADA6B05B4; Sat, 28 Nov 2026 03:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B656B05B5; Sat, 28 Nov 2026 03:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CE06B05B6; Sat, 28 Nov 2026 03:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18386B05B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:07:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F68F8061B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:07:44 +0000 (UTC)
X-FDA: 85483798848.13.8035548
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A8E8A000C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:07:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TowH9GIZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795853262;
	b=zNB4d0lkGMPRdS62plrikbOTbvN7YZCCZO/ok2yvRWPCWVfGiOYJlEV32YYQiWFn/xHreq
	zk9d4/dLJqrQcxm/oZ9wsVelx8DvFo+RaFZE5ZJJoBXGTlxFnmX8iOXnJP0VyCsrd2MoCR
	f6+nIJ1Vi7V/Rx4dC4hCFK2uBvvx3nM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795853262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weWIpAhr3amneDG34J839D6yvW6FBK43ztqdqUfv7tA=;
	b=oZvfU1ws9XXJteAnTMsAR2GAiqCru25eywTgOqcvqJYYSmx+eVO0BTWKFHlVLKY+RKhRuA
	qhgq7a7RdxSjInuWGHz+PcY/7Heg4YQR5I0TzDV5eZotfBChZJykvF/fjutLPv3EXTQVxX
	9HraqtZr4RvQR5carhLfelyFslsU+Go=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TowH9GIZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3ada81853so9561067c88.0
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795853261; x=1796458061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=weWIpAhr3amneDG34J839D6yvW6FBK43ztqdqUfv7tA=;
        b=TowH9GIZveyC1RRckCpPufIILb3VloTuoiVSy9Tza9qL78JQCmawbaTrn/NhotoQDN
         kl0bPCw3rF+/EwpCQCgsG58hMbBoWAcf4DAIgyuDT8XbP4pPDXfdZ0+uSLy8H0dbow+J
         EI98L6sTLtoKDlHo5tld8rDvX7tDUyJ3y+kZDL+5akASbb2WzHTCKjlrqS6m4v2Pz0TO
         KG3CtzacJAyxwF7zx1z8LGRNVlClG2BL9jPsnD1RWLaxqyl9WfS00w5J34AOkmqXUqSV
         zuFZxvmJXmUle/jREAHqT4HSCEHPR5HH09UNqKiB0ZsmnB+6D/9P/CmgtI+cGl3e8c0N
         8eeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795853261; x=1796458061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=weWIpAhr3amneDG34J839D6yvW6FBK43ztqdqUfv7tA=;
        b=fAreVD9+yiB6kIgaySiKPI0k7hpFOs4git2mKFwriEqgk4I3rbfXiTQu7PLOIBUyKK
         VcvOXaLAAFs0alrarcK+p4k1bw9beKAsvOMNT8ZWkXpBKsrSWRh+LYpe4ZgCq9gaUNBU
         laaV2M9+gvyljLDJDgIlJVhllJVl1ZQT4tEFfCsuQDLSfol6KGLMUbdu/3IFILGMaDsc
         JFi+n8nu/DZt/bC0kn4MDkn0YS/4mYFxKoHLIKrnhpmt0XLWlN61u2UO1P+4EX3n3qk+
         HScOmS5AjOfSwK9HFf2A3hc14jGGajxOPBS3Bu/44dvdJMt3UhMhohkILMbaXscCFNYt
         Fayw==
X-Gm-Message-State: APuU4Z9k6A3agrkD+KtMzBWWlOIS/63GHVe0qmiO62Panrt0X0IgMlqh
	46CSpdXlkjYCvuV/NjdwvBg6tLTQnUrr5AEEqpgwAsAb3ktE6XwetVQR
X-Gm-Gg: AZFdTZe6CmBNblLkkFDBRSbta20mmXlBxTgbqBdX7eb3RE8d8vGa+hwrDtBWN6WPhk6
	yXwME5z42jLr4dOOuQXnV40hh+EA7mb5qqAVPB7x8ajtvEkqiV768nJ4sY8vyu6IqNgyM40Z0PB
	+kUrIMSU/7TuGgDFj/paIwpg1aIxb8S7zjnpf5apPJdvqO0HlgNsMhSnT00Poii97nkbdf7MUTe
	OYszV05iB0BtrsKdtEEhYAFpMkEdNyh3rU2Ib7px2CTavPujTZaR5Bw1o1VG45+akMB+7ROjVJz
	GU/4T0CTl0JV4m3atuO+Qi7c6OW3tKf97Y3r11U461tNahx3/Q/zxmqkyq8XhgNXu1nOAkzZ7+A
	CA1tUQVvaEhbCzPyF1SMilQEbXwDl3gRJZrPPaszoTg3d3nlp3CuNWbjorePdJLddDtQPN2QwVi
	R1Axnn7OKpkDvYHT/e4V3WcgPA2UNDWPlEhAFY8ymuDpMgA1503Nj3bKllCo2n92KKM4wcIbXu5
	/ZIJg/tuRx+C6toXBA4jb6dBAcf/SKHEpkHRu4K07aQiMXdcBP9gXJjTJQM5Ey3ISSghex3nWl/
	7EBTcd9IXSkHFCI7URVzJohTpDAsAwz1b/FhoyOjQ9Dv7zNASeH6KNASJ5ozJ9TNrdNM
X-Received: by 2002:a05:7022:3f07:b0:19a:8e3e:530e with SMTP id a92af1059eb24-1b5568650c0mr28575922c88.8.1795853261129;
        Sat, 28 Nov 2026 00:07:41 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55681301asm62581012c88.8.2026.11.28.00.07.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 00:07:40 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 09/19] mm/swap: avoid direct reclaim when populating swap cluster metadata
Date: Sat, 28 Nov 2026 16:07:10 +0800
Message-ID: <20261128080723.37536-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbVr7A91ya6P9Sbx9s+V6cVqba-avHCBnJDViKW2f805zg@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <e920cffdb3a65905dbcf51fa3520785a8c49fcb4.1795439990.git.lianux.mm@gmail.com> <CACePvbVr7A91ya6P9Sbx9s+V6cVqba-avHCBnJDViKW2f805zg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A8E8A000C
X-Stat-Signature: rgnndu575fsuzj3ugzgsktm414sxtttf
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795853262-76812
X-HE-Meta: U2FsdGVkX19M/ThX4YUpOTvnmA7GKm7GWldSTYnILkyRoIANiUtytQFhKNLQwJCqQw/yt7XRBnEH5myWAGg8aIgI8SE7HqtA84W+RZgVUt9njc3nNAgjcctoc7f0tgrVzaoos/dqoF7LAytMes943rQTwLnEDkJPxQINvm6ECJLBfzs3bpYB4AgimrLm+O9Re50ZVe5pbB4qolpIFtU+1WJ8I23djmDK+a0jlBssq+yKgLFs1FcgR7Q7Q+sZAYmoZCfD6yxJuEJmvCFkRRK6KxsFmlrbcAiaaCnfbEHb4KkrRAsxrlxK6I/TvXKFhBFjRp629hOnPFKfrOw9nrYOwLEF+D7kpaDCeHVwKkcmGNaRpW/FaEifOL3Qt9XiGYCV6AwcvyQh9bArxMgy36P2H1OMfl9Ca5B+3V0udSVFx+W1/eWEs2PuEtVIYW/RdPw796ah4iLOGAQ7/MFz8aqp9fHrOD+Ll0nsRBDAVcidoYErHIxgXcWHanXtkQlwk+J5GW4aVaG1JCkC2o5GLGSS7BnP23ZGKvL8/ZBd9Pplf6KvmkgWKPEYeV+uYjOwNOMr2qVgwPT+6ha12DFmVaxsnnR5UbYbXdahNBAogz014QEnSVAt9cGWfUlnGExFdFPCFhpOZ6NG6+8J9JV2k7zCKloUYTFzshGg7uQShNZ0JZYzuPXgz4XbSTxJ1wz/L87GJ7cZuW3fZwPqaFie8KgILveHHmU8nH6Pntv7aBUX4nf2mqK9gznbUi5MuRTjt3W445jqw8j8dOkiO3HdrvwHdXmvIV6yVEwtjjndJxj45FanNiDNwxuRjjoikXdB/eCjMXT15IybTCPtBnEqH9F27o0xspV4J/ZXAkEsSDR/ZY1PMB/S/VQgh0pMGbPSERaTBqHWGOZVKjDmYKoMPRGHnSMQQMmm5ODEnboJfIDh9Eyioo5U/23kE+QtTa07LkQHidHzqqS84jGygQrH1z7
 nqMeHwzM
 +Ts1SjU2EwU2R9gDPXl7raEPoY/QDFPR3fuNphZmAV2pENMOiRZA18wi6UTnDlqErxOWT3nklgGJ2GPnaRoByzD1jVU9luFrJa+3le7PqNkQZQBJXPP4u1E7K1O5McE4J0dhFRlwuMPj+UVGX/4f0yXvrhPJDh1egm8I6E2pEtVbRKoXFIhmzDQa0gf+cQoGExId+cqgEsleSI++jcXpW+7XQAhYJSukc9nGfjmFsK0enBa/54LbIs8X7bMl6YsXv93+40Ni//2er4wMgjVnyTp9IAtfbF1TIJuiOEt6I71m7HJrGv+otZvrul7QIS1GJoDEPSqbwGMAP3wrOKM6LKuv9vQccUBWU9CvWGi9wN5ta/mit3P4yE7+p/ky4TbRomN6cs5YLqEmBZzs0Vlp8xNTFGAP+O9yHXhuBwBCy+eSqJKvG9Aw690+CCByavw2M1mYJEB917c8WkMP1T4ZNGRqmABr0Vd7I0XNPPh8cZlnMDdsg4C+oMNUBa03yqs/pd5ay8LCjCi+ge1oJ0XmfRoRsTESzKJl+dR0XHf/6FDw5nWvQ+JgK+eUp75JaSp8ufIzzeKfTMkUuAmCydNvxMhfeW6jHLu/NilTvljg+B7OrCvz96TJpzZW02A4+cNP32qVlJ95gMEr81ViNd9HLQpArxArATDdl2nJzoYXHukz6KeQHxm477Qzi6vehvaZotRZ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 10:34:19 -0800 Chris Li <chrisl@kernel.org> wrote:

> gfp is assigned and used only once here. You might just as well make it a const:

Great suggestion, Chris. I'll make gfp const in the next revision.
Thanks for the review!

Lian

