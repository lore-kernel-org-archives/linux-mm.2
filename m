Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EC6CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2038E0018; Wed, 15 Oct 2025 04:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079678E0002; Wed, 15 Oct 2025 04:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA428E0018; Wed, 15 Oct 2025 04:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D99918E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:50:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89E50C0B81
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:50:09 +0000 (UTC)
X-FDA: 83999726538.06.F91F7B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0D98A4000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:50:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S69IcqyS;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2xYcEDiEp3Ua92vFalk7I21nwEzPa4pjb/oKqCkfyw=;
	b=l0dzOHi/sOx5hIMKx5UjgD62w5H8BArPq4e+GYfQM3E6P03YoSwBFjm/q9yCWRpO9X5Msl
	N7H4eOyJO7eihvWU4WCZBtfz07io2LV8+hv1Lz/Uchde11sZQG/Y4hvnJ5j7jP/oqUU+kU
	cppeKA1eLMnkiYlDfLOor8gXBJPeexk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S69IcqyS;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518207; a=rsa-sha256;
	cv=none;
	b=dpgohxPk4mDZQ++n4Z/qYXIqQT/nvLd5VEKgom81cvE78otwcSX02efzO+vhqYx6QhEob2
	gjc0EzohpG+eMECGBZ+XkhilxvA5PzHcWmdvDVfETLKlnBDBkh2wRo3QZIRe9ykw/kH3VF
	rIEDdYh3flqwoidPDr5dmITasOHuCcU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760518206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U2xYcEDiEp3Ua92vFalk7I21nwEzPa4pjb/oKqCkfyw=;
	b=S69IcqySVpN6ziJvnLDGn8n97R3vU4yn3apzPn9UfO6cMGPeVwhYT2On5kBD+iCSJXKodS
	a2Cd81a+chYoeR4Ha/unTGn7zUmKXfdz9TmgB8CdRhtNhz0QxBgORAAT7G4rcT4oJtT5c3
	fYMlSGuGOFae8peKvNCPPBJLIgeaAIk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-jop-m4u_PI2nqZZbq7wC7w-1; Wed, 15 Oct 2025 04:50:05 -0400
X-MC-Unique: jop-m4u_PI2nqZZbq7wC7w-1
X-Mimecast-MFC-AGG-ID: jop-m4u_PI2nqZZbq7wC7w_1760518202
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2908ce6ae6fso2264375ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760518202; x=1761123002;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2xYcEDiEp3Ua92vFalk7I21nwEzPa4pjb/oKqCkfyw=;
        b=HZq4bEj3YK/pdaYmMBba7XxpDBTsmhEMK9f67i1FePMK0JNg0m0imaQ0pblaOU2d+p
         JnACdx4HIhgc9nDBwJwFr/WmZbvp7LH7jtu9ue7kq0wcZ3DRMGxNvAAewZxWLiPb05iU
         wuXw8EjfIK2WFgOPuk51ng2kMgKYbn1VyzQ23k0XGuJM4p8gpt58NKFX4CjJFVOKvvRf
         ye3aEJoT/AkHBJoLJbhzfeiRHe2cgbpD2kclSTal71SIgSEfJc4RyrzXnK4WPc2gav/9
         TGCiBWje/O7Is3MzUJSyQ1YmqNVe91C3H1XTGmaxBIzMP5xYri6lMpNnlAkBSo1qQhoB
         gdhw==
X-Forwarded-Encrypted: i=1; AJvYcCUMXzUjO3IVZuQWY3m18w9r5Vyj9wM4i0dtSLquZnuw01UadQTUWLg6R0/E4afFft5N8Eq0iPK0yQ==@kvack.org
X-Gm-Message-State: AOJu0Ywc/pp6Qx3f0cZDvODEJa8ESol71WfrkPdoPLNu+u9OSkYXnw/x
	YGZ+ZCo3m+1YdxPOP62rzo89JlXiFK8tNcZyp6RfdIm7ulIkNTYl9mEkG0qBZP4+CGS71dLdOzS
	YPxkD/1iOiqQ6YUjHYjQ/Tdosos6FWKz6UDPiUsQ4wt4s9zY7j3wmZ3yzOIAnKKc=
X-Gm-Gg: ASbGnctvc74j44V5fbAyFp4aADW8YMIECx3b4qWFVXwRuJndralWVKkOqGgiW+MK3ay
	2w9wO7LoONTLpKtwtre/02t9NMLJIxaT/4fl+dln8Gk4ELh+CURdVp0/w4YY12dEdoLNrUm5Qrg
	PtYC2Ep+Z7rdaC0LAtQs6S65ISH3NafDKtkM9IhmtyKqfQMDcQxXoHwMmPHNSMIgkVtQD10ep6V
	EQJYdQXWlhzulEP1Bh8nuMWIJe4JjmlLWTqDetlTICREyE5QvFhSqc67zM7uj/OiUgJUDHokgnC
	NYvIiznpqtmh9jATa9UxLcq7lndxWA9um59x5og/gdJArgwskpsKZ9HCukGxOQY=
X-Received: by 2002:a17:90b:4b8c:b0:32b:6cf2:a2cf with SMTP id 98e67ed59e1d1-33b5111895amr38382010a91.14.1760518202363;
        Wed, 15 Oct 2025 01:50:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVbUHqU3QKHS+2fc/9YjRXO1Nbn0rMLG6Td+fbVm4EuDdA25uLsveQIn0KOX3/VuwxdqJbmA==
X-Received: by 2002:a17:90b:4b8c:b0:32b:6cf2:a2cf with SMTP id 98e67ed59e1d1-33b5111895amr38381981a91.14.1760518201947;
        Wed, 15 Oct 2025 01:50:01 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61a3cc5csm18897294a91.10.2025.10.15.01.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 01:50:01 -0700 (PDT)
Message-ID: <8c2c9721-e2ca-488b-b7be-c58170f6ceba@redhat.com>
Date: Wed, 15 Oct 2025 10:49:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: selftests/mm/rmap: verify correct RMAP handling of COW pages
 after fork()
To: Itamar Dalal <dalalitamar@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "riel@surriel.com" <riel@surriel.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>,
 "harry.yoo@oracle.com" <harry.yoo@oracle.com>,
 "jannh@google.com" <jannh@google.com>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "shuah@kernel.org" <shuah@kernel.org>
References: <SN6PR04MB4048CF9A242A640B29A588EDFEE8A@SN6PR04MB4048.namprd04.prod.outlook.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <SN6PR04MB4048CF9A242A640B29A588EDFEE8A@SN6PR04MB4048.namprd04.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NeRD084Ref_PGvCXe77HceOLwoPLsZcRrk_1aXw2y8E_1760518202
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qm4ky1rcwbtq4y6pxms8xpnungstwp6z
X-Rspamd-Queue-Id: 0D98A4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760518206-427009
X-HE-Meta: U2FsdGVkX19ZHw3IWPzTPWVg45JdOX8dAqFRzYYEVjP5mYypxFRpL09VIwhgZi94g29wtGL33ZhvYZMvh9jjgo2gI8ePrmqoneF7E2LITVGOeQiUWqwtXg6hMRw+HfLeAXzid6vARk1Xyahe/nw1QdtLFWaSdPt4X77ZAZiJsDv8EvFjfMS2wg5KyYp81K32c35zQtXbGmZghwcTl1aJPiVeeoHArq08II3kAw5BSjs1WrsQvAepu2giTFYAvP5yIzjTO/zfWA+FlqAKxj9LtwLKoMj9CkRbThrW1N6RKvd7LAZsl6Ak82ZrBdXKyr8B15V5tCmRJjzfJ13jK0QKkMtrGGM8L8dZh3NCfggAA3Wd5KYLVCPgwSM+UO18f+hO4+1eZVpMSEmtWt8IoeIjAHy+7MPZQqGgHtmfJhmq8PGr2Za0FyT9kq5RLALGPWJ7onFjfNjv6Wu3y5wxHRYGnvv2VnfxLqQPh6PAcozF1PAp4v2FPVd8spQkW5LaOIH61TYFeAQAWCNq8hP/AnCRHISVeFrW3ZbB/6vM8kWU9jG868wMjxmdzAHMK40jZ+BOSYNera7bHx34zix5a1t2JwA7EHu74pzh1oSA7cUIodNpkwfpYC5u0lyi3j5WukFFS+1bKUz9DmArBcmx1sZGRxMqBMAhosGfaLT6iG/udYQrTdJITYIIEFeF3PfCYtIIVwVBdBZNKcJdo3AmWA1RJQclVRaf1L3iSLDpYNYBaR/lhK2NKZzu85DCC8ef1FrazGsmadkCzZPv7rvR+Ma1ka2z33zuMPpxMU7DRF3EevcPchFe75+tRPPhusyZnWyx7+2ROIKxsPtYczuD4TfND+KEzlXK7ZfD9lHumbKNa8r/2EenaZYzMglktL92D88XZ9/3ekfd0fI8lVdSmFjE34fIOvN1XwQY9WJ/5b5fjufxMoKIpDJ1qwkbPoxkFnxmQ4Lg6M1Mr+HXvW2X4zS
 d7Yl3UVW
 bs66EMLIg548YPiwaz4Nxa54U2u0dPCFu2c5B3b2C79kGT+N0PFqXXE9oWWWn7wGyK+iI/17usJDHOSy/WVooQ0KJuBHw5MA6Ed6jYQnlQsKuDRELeL/ri60VPR6OGUWwwGKDgIMVfwlp+7mXjBX/iwIYyW8IKFFxZxpd4QJvlNisvDfnDNnjCyXkUW/ICxt/hLl5Qi+l5gUYnpw9Z7EL8DmEv5AObTwfq2UBkh3dZIjtjbjV4lLGOHA1bEK6oi3AJgZ+I7pgzPXHUjshkAnU9N7Va1WcOaW8kWiXnY8gdDjg1UY5lGYOpOjEzWaKwYE6la0wOlztMYCKeUK3Gpi2AiJtEYqKqcJSGKRjLgHy2eo/3p2xucbiMmM/D/LOdKE+VZ4tEmz8f3PIBZkAcUfRzy40nKUBFGgctkB2/02vjftTnry6khlRX6d2BdxLrJeYQvVGCDe4qoPWI3SeOQdRFEBw8lIAWFc0Wj5X8yVBmas6pg2BARcTfRjaKY03RhVhdpjykzv4lNQBmxzESzORjvHi2NxERouMmUaHuTgkPlBiF88dTcoI2Qc9K7PVRvS4FkVs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:43, Itamar Dalal wrote:
> Add a new test `migrate.cow_after_fork` that verifies correct RMAP handling
> of Copy-On-Write (COW) pages after fork().
> 
> Before a write, the parent and child share the same PFN. After a write, the
> child’s PFN differs. This confirms that proper COW duplication occurred and
> that RMAP correctly tracks page ownership transitions during COW events.
> 
> Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>
> ---

Se my reply to your other patch.

For the next time

a) Use git-format-patch that will automatically add [PATCH]

b) Use versioning, e.g., [PATCH v1], explain changes since the last 
version under the "---" the

c) Use RESEND for resends, e.g., [PATCH v1 RESEND]

d) Use git-send-email to send mails out

The b4 tool might help as well.

-- 
Cheers

David / dhildenb


