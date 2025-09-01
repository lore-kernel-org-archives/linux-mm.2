Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568D3CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B457B8E0028; Mon,  1 Sep 2025 06:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CB08E001B; Mon,  1 Sep 2025 06:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33138E0028; Mon,  1 Sep 2025 06:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E63E8E001B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:01:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41D8B1DD6DE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:01:02 +0000 (UTC)
X-FDA: 83840237964.06.BB4327C
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07E6B1A000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:00:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=MlMWZhKD;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720860; a=rsa-sha256;
	cv=none;
	b=JWybY7t0/gU8YtQ5kZ/jSRAk5oUHy85yWC9ZeVRA0+oiUujc3/+qL7eVeDcJzbzm5/f7yH
	RLNd5zuzVRDcK8WXOKkdtKPpQViHTSj30QOY2nuqfBAPp2b92ZcbgLwpOR6LCi1trfmDt1
	96fDbbcHjaYwPOuuJa5bNvBRcqtNQHQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=MlMWZhKD;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZtA043f+9J36uYAZQCeR3xnwdSFMzlTWbO8nJwmBYQ=;
	b=tZHB8Od9Vg6smSA6GHHBMUDwAVly2Z9VjCD4keK5T/XG4nAJY5njpio3/2heObcM9RIgQ7
	UHazafaKXXyiNmKSoPN6UGXfC7f5WRZ2TX90MII+617CQYJ18W/HHMSKWYLgchcyyglakW
	5GyZ3VBSRxqf9IdbiNUZQWfraFHWk9s=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afec5651966so125359666b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756720858; x=1757325658; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZtA043f+9J36uYAZQCeR3xnwdSFMzlTWbO8nJwmBYQ=;
        b=MlMWZhKD0ryVBy26/aFhE8yCP0QZGeNQTKLGYtbYbxEuKu3npwVAclzFysaB0n9owf
         LBFyp5DMfytu8awLHEUOejQz1MAIy/6vzorsmQ5xSeFVg1PwivXV4wTThDwa9+IgJZ58
         aGsuEp7/z5a7MpStZXSV35FrDM5JgO+QrDZghL130Nw2oFJ0EyamN9Nvqj+cu/UcKe7e
         3RSrtCIz34AkiwVN8yEFPFBXIV952IKuS4g75YqGjHc2Kup6wpYIgAytfdz5TCJHeHeo
         zJ3JGbD5aLOVbvHZ08TL2dGAP3w8yuZVfdeWxVl/5r6ZFUld/GftAdCbiUqR4hSQUJrl
         COcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720858; x=1757325658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZtA043f+9J36uYAZQCeR3xnwdSFMzlTWbO8nJwmBYQ=;
        b=cTjiZkP5eXsLsl6mjTtx11RCFy7T5RysgJcYs7RxIiCWl/j8KGnuDHz0sM+qsL59K2
         jN7irBd6uUhjYuoZgURCQoyvmmgFA+tckOSaZupBXIq8828k+cHLpq2hHWZ9lLRfDN2W
         kKlRSSydRoNoSa3v5v3t5spkuACq3T/ek21VZgHnskl5PVwYi7Z4veQtwbTaIz1qciaa
         Uk4UOUS9oL5aVGN2ObjdkCXO3eYkDgfMjT54s5a6dEjuKVBxgaSIwuG+uab9eH3xALsD
         yUMbN/narCuYyT+w1JqV6w0jicBWBV9nWts1fVK4J3NirZpEkbjB1wy19X5Xdfml0C2/
         tevw==
X-Forwarded-Encrypted: i=1; AJvYcCUBvqS7pqRoPSLaUB7LsQTqdtJMCXD+Alcfj6kyobu+W7mhAaNK9HjzCighdPYtmtAz9a0GKiWkrQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3hXIR9EO/Jya5pmSkoBDQlYSe6PjgrsvbetFUAsh2srXWIIJR
	mvKeK6pLhIzjJj07EiGtN/zVFxloi74UC8uMCWqZ9SIEVWGs3JmNjVPv9wRXn0LOgIYwaxq2Q6f
	XVdIuNKBH6tkan1ZXKbmV6yj4oLEqGvzqGFTrIyZgeQ==
X-Gm-Gg: ASbGncu091sXnk1eQcrxPmaSvMauflevbo/mLPTx7FLojUO60PZK52DXcy+lvCOG759
	wCugm3PNGdiTYfc6zUg1UtKNx+RtfWKeub5katBgYw+xfGCb+kpetGl9FezVeZ4j1gsKJ4gIopG
	WpX1nApz+hFplsJ+uiMPy6nv2ySos2nejFszRpLtfZ/fKiDchUPq2utmHcVaoW+5X+KIMDVyTSp
	/ehhNee+SpnwtX9AEHg0JiTVp1d+kEasNIIPlVjni2yWw==
X-Google-Smtp-Source: AGHT+IFFGUfCdIOz+No84FDiodUHrtTEKs86fTObEn6rdLKazh4yTfRj0xdajRcJIzy0MlKpo8dtV74RUFC1PXI/Aw0=
X-Received: by 2002:a17:906:4788:b0:afe:d5bb:f424 with SMTP id
 a640c23a62f3a-b01d978fa6fmr674225866b.45.1756720858484; Mon, 01 Sep 2025
 03:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com> <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com> <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com> <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
 <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com>
In-Reply-To: <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 12:00:47 +0200
X-Gm-Features: Ac12FXwPOfV2ePklaWMKvCg_OF7F56ytbjMw092zZPB8xbwjl_q_F2iE4VQLqzs
Message-ID: <CAKPOu+8YMLrtqbhhQ0SgfQN2xErVhZCLEoStRL-YJy-SeHE8ng@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 07E6B1A000B
X-Stat-Signature: ya31m8ctas7w4xncdspow5d1uuamjab8
X-Rspam-User: 
X-HE-Tag: 1756720859-503263
X-HE-Meta: U2FsdGVkX18emjRTV9MlEe1Yk8vW0Dn1txlbr/mC4EoBTQxkvgLoZM9kwX/DWL9E7Emm5i4kGNJJv2MN+pb4eumlygJIGuzysV5Q/DluCsxsmP4DOss0B6dbqfo3iRN2mFC1pSVL77EePsUGuHO7+DuXMIM3N0v6aqwNRrHpWA6q7MK2HeQc6w48DNTdA6S44iAdVRmrTbTnZZRntfx3YgPs9td5zwpqthLTY0WC+ux7/bC/FiRIwwRBV8sdGxfeh6xeCVexAx6YOF/5sa6HqqVER80s0AeK+lnvOVd9F6ayqBK2nO3r3wqzcplPxmLNX/G8TbVXJYeyzWLZNJkTBUeJsJnTIX7MosjPzs6LujVq88ZvHONApSFXsBzdAzCuAzFvpkDZ3JIUnd6raDynMNqDjuVZnhmO6LLQ6j2+A1Ptseb6urkGfwfhlo/piZ/Nggiyoon2eTN86Azw1o/e3lPPDK9Cncc1J9gmuixMOZvDiaaf/7VWGF69DDf7nEnh/C48wXJgdnbBPx2pudSOM9MkBbvaP25VYM+XJR2uVUFxcWX0kGW+90uWosGx2nZNBUwDCyQL75GGGdSFmB628AdzJHyCSt7e12G8Tl/tWL4x7xamlX6CDc/YRgDaLKSEC0Hl9JoyuZS6XWAqtHOgXWUrFKPUgl4f3LKM1JwHCBkqHNXcZtupeSo1gkIDS6YQohXlNoiXDf3vFFG9laA2xKIi1IJhpDNqY+uf9L/PUIc92VeOo8Fji++1qV0tq8s0kcz6lJ2WMkMu4USR6KNjmQ18cWIzAg9ecIw30TPyQx6UWXfEIwkxnG2el6SfPWw1MODjdZaZgFeLZOm+UShqlNAqu9jgFvQdiCtcvR5Eu6rZXjo9W1l7u0FZXeSeXJMzXdmW4Amf7SXqaQT6D27cV6U0UBn2RUIT9LkLyo4ujry9OAQ3qaVXNFQruMQTImpx5t1qQ6vWfAFKkNFc4V+
 yRmxuxJQ
 8aHyVyQ7egLtG+ghwjNZjWEfYxI4dGEQlIsr33x3eqe9+4ouqXeN9zocUN4ZwCCZybL/C14Q38FvQZXjrFTOmFJuBgvGb7qy9Z5MPupHUu4G1WgzG628Hc3kdRb3vDlRpzochMFbJlLTLNDmq8MWJmgC0oMev1OTpviRBjhgFefR9c3XYr1vDITxtJC6/tRD+kS6ogSElMFZDQA2vdycUoPzmjanfjULUgPBN4o9EDtBtahkKuCMu/NAaiJiJzhK7btdi7uT5XlbKVOJtGNWP6C5ZM+vou8VJ1VDj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:53=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
> I'm sorry, I have no time to argue about the basics of writing a patch
> description. I even proposed a simple example of what we (multiple
> reviewers) would expect as a bare minimum.

But Lorenzo Stoakes and Mike Rappoport wanted much more than that.

> If you feel like you need other rules than everybody else here

What other rules? I get confused by different requirements by different peo=
ple.

Quite contrary - I want the same rules as everybody else. For example,
the same rules as Matthew Wilcox who already submitted similar patches
(with similar commit messages) that were merged without pushing him
around.

