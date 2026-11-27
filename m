Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C70606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 00:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rZplWhAz
Received: by kanga.kvack.org (Postfix)
	id 73F606B05B0; Thu, 26 Nov 2026 19:38:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDD46B05B1; Thu, 26 Nov 2026 19:38:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF6E6B05B2; Thu, 26 Nov 2026 19:38:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 385B86B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:38:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8195140133
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:38:12 +0000 (UTC)
X-FDA: 85479037224.19.A116E85
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id C722C1C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:38:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rZplWhAz;
	spf=pass (imf21.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795739890;
	b=g13jUjXij7oCRbCszwO44yX5+fuTctizmk/v9QKswbRBrLBiocBKS6zE8yiVC2cDnHQ8zg
	aO4o7P5Tju39ykEzSzMEjqyAPCs+CRMLS0WVh9Vx4flZPgelmslKzAAsCiFnzfm8hm2FtV
	Dk3EIPxDkwXvovAAbujby0SC55pjqM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795739890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWsu4t1Z6rR8vk07XEWna5nqyMHBxZlP0kNSwzNj69I=;
	b=rsu6aoaGb1s279+5dasCfR8LO8luj90MOKjId6olIuaDW4OvO+NLdl+lQ+2ZjU3JIAazko
	cFWkBFaRRpGPbTgRTh29TBInChR7KZmx+K/717f6XuEwly4ACUjihmJHApT7EPFo9cVuCG
	KAkPVIL3XKyAX7wH45yCfZm2rG4gbLI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rZplWhAz;
	spf=pass (imf21.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4a9be758734so4786705f8f.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795739889; x=1796344689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LWsu4t1Z6rR8vk07XEWna5nqyMHBxZlP0kNSwzNj69I=;
        b=rZplWhAzXgqonw2N4OtX3L+pd2NZ9hJugNiCMOiHPzz59VrSjZSIHITNN7bzJEWtC4
         rkrXgirAHhUribrXooEMoMJDlQIKGaXGCyaxc1EJg3Ra361w9aK5KsFGarO1Up3VgVX9
         n7kedArKCpVCGaF/7hTsObsM83lFAl370uHlpGz3QJjDjEVfYPuI3xMHlUM8oS9mBMkN
         Y7g0RFdBl7CFSmW/uZ5CChbQ5QHBjnr5uRHEdjgOPK+QYpcXv1HT/8Qa+SmTMqUlbTms
         xPiK1QMVlturzMA1GPltxyYk/q4SJaAsh5yrkIStwR5u2UHXl4R+wXNQ9LhTQhVZ7BZm
         tP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795739889; x=1796344689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LWsu4t1Z6rR8vk07XEWna5nqyMHBxZlP0kNSwzNj69I=;
        b=j8G2nbw7wgZVe5BBinu7crU1dm1iMVozDGDhU2B/dqZT5Uy7j8Nez4e/ycofDU5a7q
         ybhDIZ30qrn1Z2UN05Y1by7W67mbncrQgPBGCF4TSmwmlROXTpZEY57SyEEi2OSHV+Da
         PgpPY3lNPAhn2wEojmpfU72MdCmlkUpGHqAWM6Kk8OkvdWJ036mZKcmqyuzEXxiWBQJA
         k4mmsapMWXMElaZ4lJckE5cxYFOthudOMYaCOCWDvOJpfqYMgVw2/4/MVZtgSwFW+CZ+
         PY2aR4HjwdKqPaM3BFxaWME6o5YzAZn0lbeaQfkQIUzKyQ7vpfTCXS4qOOprtc65wdTv
         PzOg==
X-Forwarded-Encrypted: i=1; AL+hErHftqel5ChdRuUTGyQJtheIWphqyBXIkJlCDc26Xfx3pPa9pwq68t6eMBoV9e+bozT9y+Cn57cTnQ==@kvack.org
X-Gm-Message-State: APuU4Z+uMQD406WjyYn5FqoLb6LP6BUaHBgpVvDcOuzRD9kBNrJJpFUz
	77f6Z0BNeia75VHM9uc5Rd7R5QjUq9CT0QazqysAa3Pnu0HJIwvxqaZK
X-Gm-Gg: AZFdTZf/ASSy0GdQi6juwdMO+WLAHqsqVkZb2AhEV1fgc2ecFMd6jTwZEIW5qvJDYqA
	r+01ryBwhTT0iDTuP65Y6FVDB1fl5k9AzGB7FQrN8ZHaZ0mXzvwT1q52BBgUldjU6Mace3EJ6ZA
	6idWdJ6TAZl5vTC34CdzQwpQ51yfTnTQ0/5a+LNJaUPDybGPVzL4btC5yZ5pyX7e21JTl8Y/Ysf
	9oTEbp6SmqroY2NI49xjfWeYCKdYpRWlI8A2D5G1PjyqlztU0p1Fz3b69UqtOIi0TBUZ/ySmzDL
	+ugZdG28R7qaNybcErJcgjR8N/nbPaYC9Htjn5Blow2x70JFqO9MVPYSKAbYtWMYdLl3YQm6YcK
	wyPtsG0hIH4prYgoocuWvPMKlwvVWwP8e32NHhDQD7WzKBZZJj1pVbkb5+5sC21cM0i2AvRto67
	maXolW11URuDbWIwhmlFvT8IytZDCSLao8HDhl9MWPVUjFjR8eqDivktBrH25pMnVjxlyS5MCg1
	ngmqHgUK2zy3iVr1a4vZkGdZ6e0dw2Fd1H/VKByTBK7OZ3ido4xTj718tmJ17x6z+JIdIcnAAVq
	274vuWOOY/ly8nNWJMvfyh0CZCU3kTEwu2VJ6CrBlglCc4VEu8gNUL8qiJphb3Ccn69kH/kHcgI
	cktzGhr2gPg==
X-Received: by 2002:a05:6000:2503:b0:4b7:8178:f7ea with SMTP id ffacd0b85a97d-4b78178f825mr20085072f8f.51.1795739889037;
        Thu, 26 Nov 2026 16:38:09 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.21.14.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2c8csm44693592f8f.2.2026.11.26.16.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:38:08 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: willy@infradead.org,
	jack@suse.cz,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Subject: [PATCH v3 0/1] docs: filesystems: update filesystem type, superblock and inode documentation
Date: Fri, 27 Nov 2026 01:32:35 +0100
Message-ID: <20261127003236.20196-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-234265@kernel.org>
References: <sashiko-outbox-234265@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C722C1C0003
X-Stat-Signature: k4ufhgr477z14sbzoju386h9i16herhz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795739890-116314
X-HE-Meta: U2FsdGVkX1/EVkEySwypbrKl+47dfkU01URFYuTsftCgYv5ny9SdgbzZYMfNrtb1nelBabLPfkffXz5sdFU8amX/Zp7ePmts95E9htHq1w55IwZy8iBVm5UJuP4quDzeKsc+CEmABiR8yaJNp/973kLzB/sE/jgbSHo2LLa1AT7iNuG+qqoZotKZhrFNkdADZaJ+Y8srpuKv/+CY+gcuy7/FeiyIFFZbxxUvvAntZqo7xvBYZdyMZU2fYzjrHUh4fj1JtcMR6uEfYmsAOaWh/8o8dug1v0B62gKRWL2d0QyL7e7OJwOPHRQWYNQCt6832xG+EddrOYb0zmeoW8Cy3SxTllEknlbj1/I+thuUiGdzgU6QFQUd4kGtSqcE7fnjZgdhNwBOMnp23/cCL146ZVhfWPBikOuDSgD+RXAK5LC0kRdh3yvxMwJi6ah22nvmGu+x0rT7FdEpbtodjLYCHpOoFqeqCpcaGYZuIwPuD0VSDdCIGIdudoe7/DZ/6OCw1fC76NmzE9eUwbJ3B6AAcJFJx7LkBD3lp6jzNPfDc00pRg22B0jFBGFClDaNqPQb46MQs83ly8Pom2fUlWaIvabAyhT1kOPuJEt6AfmD9AB3YN3no97kE9G19JABP60v7Qi4xIGUJW/IQ5MmrGMvCJ25rEIDeBqIMAmNIuVX4ySp6kSN8Coqfdg5qm4uvCZYy8elFKDNFi2SuXWBfd+wzdcxJsCuyFpkWgJwvLQkaGftZx/26AB1ihhu057mzmd/qSWp47nOG47yHhg9i2a8CkS2W2bVLP6yZPRMcOd5KMlOnYTNciKKxzqLMLRgKDU4+QrC+kVY4aq74xi5APwUJxb8JKV8I/PpMRXuQ3LCo/P9NVlOuDGv8WvLS9Xxt87b2olmTM2VrZ7EEeNiQU98U0d8Loy6brDv9eBBY8JrzbBJ95e1R+khcDWEieQj2W/KaLcUFkwR3hlTYO2aTyu
 gwEuGs+y
 cACrJs3xFqgJWmEecybeUjcIjaLImcwbHZA2wFdyAlv9ckpRjFXC14mdz3T2A40HN+f58IpByX3V0uHL2wTKjUdRuyIUoWdp29LpDcgSOLm9N+bMqIsO88hJ9m0rdAlsg1CFNIg/YJNQ2/ySwZzhNb0hT6sEXXCxjJEvudK7g2Yjr42gBL7vgsf2vLL8gzv4msYXjXmt+7dWPdlFa22dP2sJwsXrF1CUwBZD5PhijQML71+4B0ngzmbVq86pFRK90I2AhRyJqznU5GwkWXmubrEgGCTpD2+OkHBE8RAQsLbv1WWopbmwJABANhEeE2TpVYIKU5jAtxEW5IswpD0UypG1F1wqqSMOMLsGJG3UD+lKondemOmqZN/oINzY7wmPCybpmJv9qPul9tfTycYS4APdNNtOJ/2bqXWAYmtoRRwAyKt+dZZxTaHBppOzl9AtAtUU1g/YKne9+jIU+L/Pwv8Bhs3J9d1VZBK1UOppwjgG1Py6LwxfwWcxoGWasJNMxNQcuCrFymNwG5OwSErHcoOQIeeLS3gpxPyy5XsajrFv/dSGVJM46OxjmEAN0N933McY/hUpslgJyDb40dlCTU0941/lw0g0t9uY6zsdMxkA+feXfXNZO41DzCdzoYEZqlrYk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Address review feedback and correct the initialization
description for ``file_system_type.list``.

Changes in v3:
- Document ``file_system_type.list`` as an unhashed hlist node.
  A zero-initialized node is unhashed; explicit initialization
  can use ``INIT_HLIST_NODE()``.


For context, ``list`` is an embedded ``struct hlist_node``:

```c
struct hlist_node {
    struct hlist_node *next;
    struct hlist_node **pprev;
};
```

The initialization helper is:

```c
static inline void INIT_HLIST_NODE(struct hlist_node *h)
{
    h->next = NULL;
    h->pprev = NULL;
}
```

Mohamed Ali Bouhaouala (1):
  docs: filesystems: update filesystem type, superblock and inode
    documentation

 Documentation/filesystems/vfs.rst | 181 +++++++++++++++++++++---------
 1 file changed, 130 insertions(+), 51 deletions(-)

-- 
2.43.0


