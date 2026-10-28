Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C39606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hw91WjyT
Received: by kanga.kvack.org (Postfix)
	id B447A6B05B4; Wed, 28 Oct 2026 12:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDE56B05B5; Wed, 28 Oct 2026 12:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BCD16B05BA; Wed, 28 Oct 2026 12:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B44D6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:22:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5B67140183
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:22:45 +0000 (UTC)
X-FDA: 85372553490.13.B867CDD
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0936240002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:22:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hw91WjyT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of glider@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kezU2v+NKGjN91NZ3hZFAcR6Bch1I0pICocr5RDNRk=;
	b=bpmfmqbgm3uKsiIlYe1jfOnwDJJLKlGhSxzxpBtErGEhF5BytTpV1CsScVxKIJcGfcXhkp
	LqKh90IdGVNdnTebkKm61yui40HGzsEdpZivn3Efhwb8EVQCK4y+Y/OK8Efwx+TpZJJo3+
	24jDgJNr3KLbKgWXiVWfGZg2POqFjik=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hw91WjyT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of glider@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793204564;
	b=5lRkrJTQxKgARCIskNqv2QX2GO0g/GAoRzYwLzpqM/5+5M2n2HLKa2YFRxcs1BG8LjoYZj
	TrnxGqKuRVoqIT6IilGXrJ/jkqSBzfdo9xgDwqfduwIZt/ggaHTigj8t9Md/aXUwMBNwMj
	adjpbEXnhFtPI05CWsFnd6e+OGQJ6q0=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1a3c08d6928so1603706c88.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:22:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793204563; cv=none;
        d=google.com; s=arc-20260327;
        b=TItluxkP1VO+BDuJAW24g5/PBT+lfHgtCckxfLewlHFAa3fci6Q32x8YZonDmgcFHc
         KgBHLcCL4TMBd0hekRZ7Vg+fazlx/KDYm7ybAjvxSStmG3Hy1gxA5JNyF9CT++/3qm/f
         BLBn5oiak6csHatJ8UjAyQ3RrpYsnqpN9X+joe8ymnNjldaUrPWEQxgMaTH0cbRF/FZk
         G7HPL51HoSWDk0U83n3M/YfBOXtCvvfx+b7TrUh6TMEaZ6EqoiOEMc7H6czENvVvVZIa
         i4s0FyO0jp5e/iKT6XKgI/v9yGAgpeQ08qKRhqakalQCBOhDsu/3mnIuobPx1WgAJ3Hj
         rBfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6kezU2v+NKGjN91NZ3hZFAcR6Bch1I0pICocr5RDNRk=;
        fh=kfNtr5f+9l3z9NCuW6Jz60EFGj58I5NAA/Q/+VYLR5s=;
        b=ZmXg4++1P6uEQHnDOYuJDf3vCKt6hpW71OulxujlUdYcyHxuOR+P1q9lYAvC3+gTVu
         mYKa+r4HZ/3U24laK90fss8NqxLM2+ZIhMmRvUzuATxl5QcRKZg3HW858sMtBAYqjwNK
         ahcRwuvXfu9GiJ5vjJdtGGTPywyDBuiJ//MPeK6O59fvEj4aiwe6bNPn1A+6vrRi+CuM
         mPAW78CWey1qPwzekjRqeeA+K/KIEs5yIw5IAoOraV7k96Hfa1M9DFZ4lEzZ0tjIooLM
         GDQEYCq2agEkjjt4nsUBUTpMGEs6vbeP7sGkEqEQiBYf29OtBC9lkp+zaiEWT6R5Cv21
         CPnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793204563; x=1793809363; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kezU2v+NKGjN91NZ3hZFAcR6Bch1I0pICocr5RDNRk=;
        b=hw91WjyT1OoX6Cg+38lTqSmRNz7BRa6Upw4PnwJ1bmb4mQFh7vvfsI3lg7svaFogSj
         P9q1xQ/1P2Lg22kUSMQbHY/qNzWpnRlBCJw4xUnb+EM9e8Ys1cG2LBVcItJMO+m43fFM
         hBjG4pKju2kNTjJbcJLZxF6UwRmaFYBtfCTqPIRxx4RrXnHvSSDmn9GaJxI5H9zxKlNE
         aJIlBDT6hZ9wDv0ZwfbS+vzzFv4FPjIC6uMaq9mnD6526NO5+Xurz/3bjMyviQB61usG
         Efh6YF6zSpZFlSPOCivuNXAdlQeTgF5R9wdkD9Z0ZKPzglHsbgbj150R+1Fxw4GW9xRU
         pyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793204563; x=1793809363;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6kezU2v+NKGjN91NZ3hZFAcR6Bch1I0pICocr5RDNRk=;
        b=O0bfww+VN5OUm1Fuf+IiGdjr7Kzih3mKPpf9Qd0poiTeFvzZmQik1dCPXCmyzJLC9s
         ssegGCFFN8cStK2rCTH29O7hHGOendWOe2Nt0AT1lo/m+RzV+k3BqEjKnEmvMLpVvuVW
         yntBUKvPhq/uFRy613x12mIXCyg/uR5J45ECKHsQZ45SGNUPNgHn2ElEcnPjJwmNDKEo
         dvyY3glSPerEdV98zdn04qX0qWt9Ee4kkEW5F+3WWFKNZJTJWXhul9A4FM/nfRDg5uMe
         zT3KA0fQnczCpH3WyIL5O0ecwhjwrDWWndoXCCcBRwmeuqDB+63zXbIwiKcr06bXMfUx
         K95A==
X-Forwarded-Encrypted: i=1; AKwUvBxWl3RkdrKGQtu9UlzEtYfMGu0GV2VXQev/5Xmwa8ODYPaXj+Ib7zmaAY9LTIRl4S/Kl+1fy1kjgA==@kvack.org
X-Gm-Message-State: AFq9FYIF8DdgtHYkpU2AbBeUPwINV4C+u38JPX3xAQopK79oB779STvu
	zh53FL3hjeJWMyEvhP7mEruvvZMUPkjbtLGrMAtbDOsPpAW7vRkxDvMooT80vAebQXaMiXIXCJP
	QzJENX7n8jzvYzeQgyS6YLYQcvwG+tAggEOpp4whs
X-Gm-Gg: AYBFou3yZeZ5RMN+URtlJnfd5NvWeGZsAZMNadWEOVwum0UGEjQyyqB8pNXL6OWqDvG
	W3/rfOt5u0DHu4pSuEscRb5Sf1LSvu8dNGusPng2XqPAhg1ZcAqCmR6+/ntSbpeVpeANQ4BLiqo
	AbiQFXmRT5o8MxQEJYPLFOXXOxzKiRef7fjbBqumbrfgEpgikaiisbWui/PS2CmcBqNV///PKSo
	PG3Ala6VAx7v3dzs19Psgqxm3glFqfCFkz92G7InUamvCNTNhATBXldPwzAuLf6Ze8oNJaedmfL
	EXh2naWsgUJf9VtYptdxFo8lNAKD3henxmvndXSJXVTU7G0a1VWPuiExswjA/3cGxwQGzKkzMEc
	61084zpcxZOifd59M1Y81zCDhdMOzQ1xQMzhG2jBOAfm7+FT2SwTYmQsOCONFTO3vRw4=
X-Received: by 2002:a05:7022:c83:b0:154:dc96:c1d8 with SMTP id
 a92af1059eb24-1a6c87bc54amr3796777c88.2.1793204561410; Wed, 28 Oct 2026
 09:22:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027222557.1072105-1-kuniyu@google.com> <20261027222557.1072105-2-kuniyu@google.com>
In-Reply-To: <20261027222557.1072105-2-kuniyu@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 28 Oct 2026 17:22:04 +0100
X-Gm-Features: AclHuK8SJJmKJCygPjX70tKlg39pXhcmB1Rybbm2FOLQwjSb5QE2ZGuFFIMmi3Q
Message-ID: <CAG_fn=Uw-MwiZOt83wc_oUDUYz0UU4C0dG2Rbs-aEp5aUkzaEw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0936240002
X-Stat-Signature: y98m813uii3q57sk9mmnruysofs6mm5n
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793204563-947728
X-HE-Meta: U2FsdGVkX1/JU0s3KkExDA6Ba5l9GFpB4RoCwlpkw4aCxfolzU5+Cp5BSmu+xvG2srWuHq1CRbzLWdByocOxJBlkP9nxG2GBOGvWPY5OqP0xs8vUy/zBUR/QtK7XaU7LIIPYUq/UGK8MUIWSL/L6+rTVSFd80St+WxzTrq9PM2uweUOq3J2MJgE/QgIMJFLTLtOur7Ct75ylIeC5DFwuqaN78cd26tbsYJ/2WiTW+QLhUGilhrRsACi+m8vOQkLdrx3zQWW/ufyQEAif1BQZTs5fxH+9OhdeoCER70FhnDhhe+ktPZOxXnpawMQeJQ0WCmIzqSR4FzEqz058X3JWNB7DHP+aBEFQcD+UTzq3aRA8xOHmt2H+5JGZH1hL+ygYOZKY50lWZukER+W0KjkyQv1gMrHdGed4fS3mtxeDPJql/xqXjEKboZudYrf/5uCw3/PQe8XG27eLwHg9GEGjyznQhlN6gdjCyiEVdCFGsZusUVRfb4+QYF9lBKmv3jmRt8iZGzWWFKi1jh72GLFm9NWwh7Vvv5n8ttpkkqKj1jKaOUSc5zsKwnz1pzNZwRy6VAZyWgYQDTM8UAtm8VrPWs8IhTkiCLfcSdDvKBQdYKZoiQAkpMJYmXMZxjzP4s4uQfngf7OrXFDBzgxqFDDVGAIshrX9YCzV1sCwC3bLKFASgkgW6KrzGwFIRze9PdTRTjSSzXwoHkLXyc+UfVNEp0Un5v2Eun/2sZh+y/Fc4ABOZqxmKYkFZaTuFLNCQATr78SDxvoPkb7+BI53jw/oFMzHPlav26mBCHhQUv+n4KkVWR/QKhZPP5oYZ/ec+EXW40iS5mcodEAepLjQdEDIkHZdnJ/VVuuENmTapLkEpPBnXzJ80XzJC072ClQumFhmf5e3wEvioZWH7qq1ev3xc7kK4vq1c0w0PJf98H6m5OEIb7/BzUo9Kzb2/c+7N/DURpKokXPwrbImTAXioVI
 tEiHMF/t
 Nb8yd/1CgB9KlhhlmnPXal1WL3u+Ok00wSVqKRMUDYUo2BPimn1E3+3h/f7GG+rq0QjXjRQ/5SZsUm8V/kwDSaNSpwJ71csx+Fn654lC2eNP5Mf7Qgx6HCxp2NFDww+wtXvmsddrK8wfl5LZW3/GgjubZ6VvPcHJ8s2WDHD55Ojd34mk0wUAe6CYR7bNaDbX/zgwp8lXc+xmPbCXFKOvJf/xU9sxDFm5i0ZtwwS0kvk1E1Q5Ki9TUKy2DbSYHDp5M0gWqiIplhva0OZut21oTXAXBVz+SS71Ka+9ezO7Ul5DXN7Uqj9nzTC+ndz5vPfO+JN0QkzJvT3NqBNglbBqfdOwvrOAJNK8coXGa6ykdZRtrSlCI07G2zAtQ600OiHDPSKHnEGg0keCgZx/OEKjh0GiiNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>
> Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

