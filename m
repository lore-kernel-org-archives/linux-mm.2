Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D86606D811
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PKpNpa/F
Received: by kanga.kvack.org (Postfix)
	id F406F6B00EF; Wed,  4 Nov 2026 14:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0476B05B1; Wed,  4 Nov 2026 14:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE626B05B8; Wed,  4 Nov 2026 14:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B60D96B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:02:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D858A082F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:10 +0000 (UTC)
X-FDA: 85398356820.18.F1B8405
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5119A40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PKpNpa/F";
	spf=pass (imf04.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793818928;
	b=U5nvZUbb/20co+Y0wc2D1ZNQBNa7kxwTtEtMd5/Jrv1VD4Fnk53RHZ7J8Ql+Q+GQjDe6nC
	sgtMtPzR3e2mbkXAh/WBmhXt6a3NXCxL1wvzXtnc5Z+3Q8Zmbu9YNaI8W8noI68eRYX5jR
	BYNN7x7sTX5qPMM8PQTAHt+EWriXoJY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="PKpNpa/F";
	spf=pass (imf04.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pwH85IO2Kmd9UvCosC1bqbkR6Q4A/lE32+TPIoCPrKY=;
	b=wREHaVecVVsWY9tZh7e5Ht+mmSVf+zOuqvNsM5nlhZSoQB9NidHigrGLism9j34QXQQFdK
	B8J8viKgsEcKgyPhLYe6hc9/n03vE2NM8sM8CyY9qv/PLI+U412KBn5ysg4T3bmN7Ls6zI
	k+PoKFbZYGt4Ls4Ke4QffFzeT5pGnIw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd3310348d2so978108a12.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:02:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793818927; cv=none;
        d=google.com; s=arc-20260327;
        b=JZ5ZqPRB2RlSlTGmKpd5RaaFAIMzGCx98GnJCRuMJC3u5Onz714IjAqMGZJEYLRelO
         JjUK9if7Wgr7baGlokIkUipUvEP8Ol4EZW0z7s4cxVl2wr7eHyB4sBcxn3pqk8AZHQJ+
         l6yy6qEOElB63Pu9mWokb5i/74XG9Mw0QaHgRC+uz+dhx8pNG+AJRWYdY3VTYVmpOKZP
         3FCihYydn/a6Fn3KCsbzBTsHOuRIFe8A7mFDWGqZABU5ENWf3GgznenHgxhIaQTEIT7O
         CIyYJtCX5G3e3Ltm1KZp2HNU83JH7ruBIuL6lqhxXa4uh7c4W6KC3VmpmQQhWMsMT4zI
         q1vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=pwH85IO2Kmd9UvCosC1bqbkR6Q4A/lE32+TPIoCPrKY=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=HiDv1YLXpVjUlm0iQZRRIOfyjnQ7FBce1Ldu8cKYdIOW/R87Z3/teKs3H8MCeF7V3f
         1UxzfycQ3mVhoD3ourD7Vh5dBmUvfHJ6UF48Xxi96H3Q6yHHhKMEG3FVTrQKKYxWKAW6
         cWsSDpKDvI3FhnfxDcI/17KzZ0XKwyihHNj4UGyTC9Lp2kJVfMWiOb+/7BIqbFpruf5C
         /Iz/UbBhTq8GPkv50HF87n1LuKGRNB/KpYqfYvOuJsKZWKPhQjzFo+8slBfVY7PvdYx1
         pXwRG1CiJWnddVtVEUx4y2jfBvrQ3TCmvNIhYyszPrpPdAXj1aP4OdTp3Asj97OMxlSS
         rG5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818927; x=1794423727; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pwH85IO2Kmd9UvCosC1bqbkR6Q4A/lE32+TPIoCPrKY=;
        b=PKpNpa/F8QBQrM/NX1HU65q0EvZasyh1hfNd4/82cXLN5GT3968sw990HIITSDli5p
         EzgcSgsdLqSElfMuvB1tUiDYTWE3E8cMYh7s509Uy2ZUxRRJ6npQlJE3/ZFQukAJIGix
         z7H3bf3j6NZLQtZ0dWgdiOc9HiEKm9bjzjuY9YLvmyWqQXiBbM0mrZ2EFXXEo3gPna8Z
         CoSllRG8yG6szL80v4Vh98YGiJwz/ojXraBb3kOveRSZEoliXc+k/0wR+R5fIwgcUX6r
         uDjc0wlXBoPT8u8nyswfpsYCRAuN8lrlbTyPjH3NNd0O5IJwPnMkCubTEYMyiVw8oTwh
         7Ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818927; x=1794423727;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pwH85IO2Kmd9UvCosC1bqbkR6Q4A/lE32+TPIoCPrKY=;
        b=PGmT+eZftONrp5ulnT1QDSB0ZzlWee1OxofxKbqHmsUywEiZl5b6hp8zB7Ep6nJDpG
         LLAdIgz34lxKOQWLwShXAKdbesD9uixQ3pukDuRSbvjVUEQ5jvKuOQXa/oYyvuNt0oJ2
         8ioHJkmchM/hfeV6o5YlfjUDrEvtYJ4x5/ZslNTOjEHVI/vWpDykquyZHI0Nb/AWcSl2
         xoXZvNc16A7qfb4QAiUwCndZCDuQjytfvC5c/jIMm2CnAV+lvwaYEKMWKFCAmSuekW3y
         I9ot61SYld8tEtcrG8rYl1EjIVWOjkXDRgynsEXjy0gNGENNKm/sqM955NgTsHmIJUP0
         ShkA==
X-Gm-Message-State: APuU4Z+Wp8j+HyZOvTsriIt4hHJhjiODyMNpiUq1PbhrcwTRWcXNOJg8
	80zfdJAOeF73td8uiot7MgE/BBds+dbFuI+pI774dnXZSw9Sd1uuwORGsz5NJKwCFsao4jUPfkZ
	TFGT4azxlB/hxDaRjJHVkQ+tozxdKVNY=
X-Gm-Gg: AYBFou1qNvpgn8NJAmyR3U5QoQsJiXtb31/nzmAQfWdDJrIbsG1L7GPNumOzAmdpeT9
	KqDnaIXvVsnC/sJF+zj/s5lJQsD7xRQ01d4qgX65vOgrXxilEi1o3FeWH9fFAtNwXdwwVfBM8mk
	hbpytnn0lJdsWs9EyC4K2eBVJldQc/SC8y2hMFqHqnNPQUqxHLGRyWdjCqStZBBbtm/RJ9p16gp
	QRNU7MnBu3fyfeKiMkdUpgMpwT9IE3sowbNZC/UWSuGlD5dO3Q0pc2y31/LRmANftCshOxS2zEn
	36BiMY0U3InRVPCcx8RRuLFntPsGnfyWk1CfHOg0+Me7Mjz9Z9RorZrg3iZvSYwpJRDf4LlzI+N
	an3S98dyfzqRGndtEVGvhRb7p8ImnEi4Zwkf/iIv6b/qj6qzDdkX8elCsOtsG2zQ/U0vjJhgTw6
	5SSNve8XHCQae8
X-Received: by 2002:a17:90b:1a8a:b0:3a0:eec6:b065 with SMTP id
 98e67ed59e1d1-3b0afc28fc2mr223845a91.13.1793818926988; Wed, 04 Nov 2026
 11:02:06 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 19:02:06 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 19:02:06 +0000
From: Henrique Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 19:02:06 +0000
X-Gm-Features: AclHuK_f094t9Aarf_ICuOIqlKf8WmOIyvUEgEjQ3oNqea5atvStlotKptHyeQw
Message-ID: <CAL1HEBAHwP68MigcYpBqTeRo5YhZY3Xfp5=HDZzvhm=SpMAA=A@mail.gmail.com>
Subject: [PATCH 0/3] tools/mm: page_owner_sort: three input-handling fixes
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5119A40003
X-Stat-Signature: 54c61pacyrujd5oepcjh4o3p8hiqq85g
X-Rspam-User: 
X-HE-Tag: 1793818928-377242
X-HE-Meta: U2FsdGVkX1+5L4Fzvt52i4MJX34EQRzTKR0+nmfhm1iqzF+Dbq3ZdLvwvelwlIVLEECjTSDNXzv9eDxHEILN093mfGsHspjFhLGLxPXvlpSotyUa5+FzbBoHGpdXMPWkW2Q7g71aQPNJGgLjxoEyZyugHBXflGMURdEFgfn14mM1eWkQzC/ulojwFZ36HuPQpddOrlginRqGOcHwBpAIAIWy0P94Klc2B4RdnstoXrpnHsQxyWeQ+7Zc0+AxhnjF+44hiK5tFIfNKTq4QDLgfHnImIyQM3ZEfBTdJKIz6KnZM6phTvVDVPZ/7T5Wi1he3reir8Db65+OE1f8yldEPIsQORvOIyAb/7q1Bwiq4NYAUs+CmbRCoV3scxOzO7oekEN+hZV3Fog65OONUWHj4tAM4x91uEvvbaSPub+cTZIwfInTB1zB9DM8JflmnrroplmjJ/ZUdUE3X1INQue8jqmUFEp9oUAaZZxq0GWs7qq/dhf2e76oqhAqGMGHukTW0h1jzZvFmK3QrsU+m8gMN2BAOWBefblgtzscvY4DcMYwxxJglibI/NmfQuZ6HTbmbtyEsLuNXQsU4j5KmMwLbVaJtqlBAcuzNx+ruTDoj+AE48hxrxU2XNUlI/vEF4JRFwXW5QIVFqC9UUA+MqY8ToCCoqMj3gUGkTUMMCtQqcRrf7LnbUxpfxmK1pcy2wSuwSLuSpMCF/04Ip/cjj8Iaar0J6q9ipU4BSgObypq+9n8Nrtv5YFk1WWbAKWRA9qGAXXRWrJaz0OwyORIfByNHVv2cNadb+EZUGli8G7XmJRvXUICl8+wGaPbdJh8I6jDSDpC1PPxgtfevhnI8mXycEvoVPPJdbwPlGt2Lq2DQ97gCFCcIiYZ3h0zEeW52Tmp3hEWg1Y4yDEOE0rDvnmEFtUdovBrYNGXreaFnK0PZOqtD+8rWemUxSZGbcQsgaGpa+dAvHJpClgL9fT+IBF
 ufsOdp1N
 hqxV6J32+w1haFZxFcGYwhiULIQcmiwzRDQX/XFkNqkopofQIadg/oWPekyh9PqLhhJRGmZxAsoqI+JAeYLDYO9k3ANL6bIhx8AQ05kSP8OgH0rFFqZ58QcovtP5fAtpAhWMcciewtpnpfbGPeoVJ6tx5t8T96rE+MQgZlKDVi34JNlkDgx2Z4FMlYFNB9MojKrLTqib9NMmjDHQo79fxBL6ESOCDqbemDZA+4N6//nGMP9r8nEtp4oraYpeCkQqacFuLrcHe0E4KtS+sNSs2xLyepHd+bvzC2onMW919n8VhIVL69Gtn6fPZ9jh+jYcKItVZxbvln3iV0QNfC8oj2Uidw8XPE/qRd7Pe0Yxp6qhveUe87hkJijhtEdC/VNhjeF2TTWqrorQeDgd5V5baWmZgq2hlK68lh6Hldd3xcdg/hrH0uiKAZjBqnCSs8ayhR2yWf1Slfuv0WiHjqexsvLoqa6AhOVOW1p+YQJf7zNJWIFyN/KcNTWIhCczBelNQD4R2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

These three patches are fixes for tools/mm/page_owner_sort.c and are
independent of the out-of-bounds series posted a moment ago; they touch the
record reader and the array of records.

1/3 keeps a record that ends the file.  A dump whose last record is not
    followed by an empty line loses that record: ten records load as nine,
    and the tenth disappears without a word.

2/3 stops reading a full buffer as the end of the file.  read_block()
    returns -1 both at the end of the file and when a record does not fit
    in BUF_SIZE, so a dump carrying a long record is sorted as if the file
    ended there:

      $ ./page_owner_sort dump.txt out.txt
      loaded 0

    With the patch it reports the record that does not fit, with the name
    of the file, and exits with a non-zero status.

3/3 grows the array of records instead of deriving its size from
    st.st_size / 100.  A dump whose records are shorter than 100 bytes
    holds more records than that, so a valid input is rejected:

      $ ./page_owner_sort dump.txt out.txt
      max_size too small??

    Measured on a dump of 200 records of 93 bytes: before, no output at
    all; after, all 200 records sorted.

The three inputs above are the reproduction cases: 9 records loaded before
and 10 after, "loaded 0" before and an error naming the file after, and
"max_size too small??" before and 200 records after.

The output of the tool on a realistic dump is byte for byte the same before
and after the series, and checkpatch --strict reports 0 errors, 0 warnings
and 0 checks on each patch.

