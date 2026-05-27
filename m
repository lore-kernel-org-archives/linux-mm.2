Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5370ECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654746B0005; Wed, 27 May 2026 19:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BA96B0088; Wed, 27 May 2026 19:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5694D6B008A; Wed, 27 May 2026 19:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49D506B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:42:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEA7712064D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:37 +0000 (UTC)
X-FDA: 84814826754.23.B506479
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	by imf19.hostedemail.com (Postfix) with ESMTP id F297E1A0004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=a5HY47SR;
	spf=pass (imf19.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779925356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWtSF+ZdJPKnDl6l0dlAcmnN+0WDS6LYwhPmb91DFEM=;
	b=sdEg2JWd9VEbSaXfasBb6YVPRRkXrDge7197z1wj4vP5RclVaBdJfBg1L+Y5I7ksWNB5Sf
	lJX2RLJ6pec5+2jMUzuxdfzDAct4CObHdjDcZwlxHgdBrrmleByxIUB8Nnvt4oPow1jAHz
	X2nnkdMLiPDhdSFfksTsE0RbZVoC9n0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=a5HY47SR;
	spf=pass (imf19.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779925356; a=rsa-sha256;
	cv=none;
	b=JkCiIWSCp6GgethrO9S0aT7Rz7z/Hqq0GR16zs3hJXJx97mvrTFOS2G0yW1IQVEoEHsyDE
	UdWKlus1Lw2loDw8fUfQwXKjLKhwSFpT1kHPKcHfsN57EzpZcSKzaWrpbS2dWAa2bFCw5/
	MvP3jVhAWIu26ejF1eyQw1kw5tR6W2s=
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-9106ea78cd8so1874307385a.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 16:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1779925355; x=1780530155; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vWtSF+ZdJPKnDl6l0dlAcmnN+0WDS6LYwhPmb91DFEM=;
        b=a5HY47SRdOeseitKuBZHGH+2tiFa6H2FMHbfZW1vjXZMBF2059xCQ/9l+j9lAx1Mes
         xXg4F0E70ImmEz5G1PNESQWFtxXQ+Z9a8kZ6dOrQ2NIYxVe3UHKenExZHC2JyGqnf7xB
         MqdCB4fQeT5NQq0B15qKVeAMv9EwDVkHomy/cstDG5qDfF1BjaTAWAcUJv96Q6bSbM3f
         LVUbXj0C8i62NSqKW31E6MM30U5sCZw9RW03u3xJBrFOYa30zhB6Qexmh2BwIssxxpj+
         5ZwXRgMDfzsE1II4K1OBolv+xwZWENDOwBB0n9FqgTqSpsotoKOatuKPjYNlsZFiB1OV
         PJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779925355; x=1780530155;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWtSF+ZdJPKnDl6l0dlAcmnN+0WDS6LYwhPmb91DFEM=;
        b=cf6c7rHdzR8h/jSJtAWECJ1E/f36soy51XHd2GUxU+2CNIoCl5K/0/CGqqmafLW7Fn
         VF4Fx6t1nvsEFUGH5KuOaFoMFC6tahNvYDgkFuI62vtQhKEm5i9+z4TwDSlQYVflMsnc
         crVlGyhwT4nUYZina+FSrRDd+ZAd4zZUmVm+zgOXDahZSvdTbhJTCifAfahA7PKVHxQi
         Pi71O7a53ZrMmU5uOQ9ySa5ZYDooD/bsTvJNdMa3tCspq+cZAwN7MsSQ6qq/6kp+z7Hi
         IkveEdFql98OgigG8dW4ouqtuKEf8h0bxuBoHslJUgTklIQEbkkp9SDX+e8eV7HfBb+u
         wpgw==
X-Forwarded-Encrypted: i=1; AFNElJ8OgklP4LZdJo8ObvFNlYeKA+8K4NiLFmjqNa8MD0OcE7DJl2OdnAeQw/hydo6Od6VjQN7zCTqWsg==@kvack.org
X-Gm-Message-State: AOJu0YwStPif8r3rruFDBwBnxk1/xo6tsl4F8dC6SyJB6cYPWFDkVRaM
	k87yBZwUWOfMJVa9x8Hg8cz9YxFhJ9xW2cVJ4nQM6QyuBmS6kGJ15CXwDSlvzjs5Qg==
X-Gm-Gg: Acq92OHVAPOTFj/teKjZNHj78ZnXB2GtH/Ilnypz8TMqVQK8YjZ9seU5oIIzj4Z/uQe
	V2/8DDDRQGkUSJ+Y2UJkwwW/Z8LgN0ZqVD8uSmjlS3RABSynsi/h9y4EVvA1yG/IXhZGIB+yphv
	vBjNRD4Kfc3kkOuwrTSLvTQ3rXw0jwEHoCDhITlVNzOi+Xgy6nVsGo0hH1w/YKnWoVPjQGRyiCy
	oTS6nJedJj/K6MwQUptMrf8fLwV+pbsEB7oZmwTwzVq+yJLD3ul+WLTFzGNlzHcgUsluZibkXV9
	GzGmUjMPV3fYx+ShDSL4bf+nHK28MzFg5/YeYU4Bean0KAHnHq9Vc8u8+TTMd4+hxO756cFwovh
	uQq6RGJx9RDcG9HqXRkI3n+DI8aOpxZYwdPq8uzIE4IZKrgMTYkwBUECfDnK2hz4eTbjS47AcR1
	NhCuiEddxCj5YmRAMzSBEDSArKTDRwF9KBdRApS4ErmAXzy+ZNoZmO90Qbvjm09035ZkmRv72dZ
	AR3AQ96sEtOmWkYjg==
X-Received: by 2002:a05:620a:290b:b0:910:87f4:9a26 with SMTP id af79cd13be357-914b49937b6mr3695400885a.41.1779925354972;
        Wed, 27 May 2026 16:42:34 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f8706968sm615403785a.17.2026.05.27.16.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 16:42:34 -0700 (PDT)
Date: Wed, 27 May 2026 19:42:33 -0400
Message-ID: <c8fb6387f3c1efa126013090f45528c6@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260527_1931/pstg-lib:20260527_1608/pstg-pwork:20260527_1931
From: Paul Moore <paul@paul-moore.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, James Morris <jmorris@namei.org>, John Johansen <john.johansen@canonical.com>, Ondrej Mosnacek <omosnace@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] selinux: use k[mz]alloc() to allocate temporary  buffers
References: <20260520-security-v1-1-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-1-831bd8e21dd0@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F297E1A0004
X-Stat-Signature: 9r1n967zk7rjigmnicgo48ysujgchyxc
X-HE-Tag: 1779925355-181001
X-HE-Meta: U2FsdGVkX1+fmekFE4mKRONxG/jiWK14E3/7YESLfnqkJiDlfoeKrD8WaPjCqpM9v8XP+mmFE89A3/g2u40TX4QLH4nlDZNlBlJ56QgbJDmu/l9eeA6U1NFFAEDQQTetqxANzB+gqUfmoo0xmalLHKp4JsCb2Pvw+VMaa+yoZeC2muDBUaIXsV1UlekwR7UN17LupxBa3BogC+bonRLmzyHJcjnrFGHAextwYq1zL7RpgrPH5+F1fx4ElE/W28Woc5BHyy1/+BKd4IWr8zKnkBxXmP/oiWSUgZsRUe8037SUTBd1pMGcJ9rszzRCAKDjwhgdmF/goZ+dQ623alC0iShv5xSpmDnoeAVcDhmHAvp/SrwMiRmoVqIUuzfqEkr05/QXu9MnhW7FaSozT51IkRduqWO6KqzbWHec2wraFJT79cVs26nHW+FrguEJdFhfzqkNOzVxejFqaV1fx25Ifq4BGDxu9oeRy7xY6X2JUq5FJh62jqZQXzBO2KqE6sGp0ZpPCzC4/2EgMoCmH21vP6yB/7tWFDFPHP3pq3sgrz1VVz+BgFQg7mqgPCSAWBRna/U3I4p3x9I84miYxiY+sr3BrcEAbqeLVVHksDGyF86LLMbUbwOJNWgBERaNbCLhux/mZC7whd22hdbQZ1NEOijirWhYgFCwqBqrgAb8L5jT6Y/WBRrE61haMFHZWmQf6+MqS5Jd2WywSU8+0afhdavKxO3k3dn9esug7nV2gO5nFiEKbibsCG4E0LIWO2rhkQH4NJ70o2YWkB9uMMcoEM3W4d/UAcIWRag8zqh5D+9cuDAZgaKOfJknAlq0UqpbwUUGTsFh9gHuObFqMbnoDFNGFiuW/DJKfpr7lhd7QusWzqVoqZIL/aCGKE128WprSi7RwsRp1Gywwz/dzWv0E7p2h45H6eRCYhrhZLgQ+RpUQQLWZwnkjHUY35CnNOZ2xRLQJDN09m7Z3cuuNCN
 cZntEybi
 OUv/1RMmebMae8ETzI17/sQlt0+UuisqRZVmpRVkb4j7mt7VzH9t2A0mI5O/dd7tHM2k06dUkKi1cPep/x//NCBS/0hYL6wbmSofLD19gd2RDaWBpagnNPa27srsQ9l+v0tky8/fKeWeX/SEUlJmc8bx5N5mwsTuUgwVWWcj9kSoM2Bmg91BX2UhJx+7oydEyvn1SLLqAeGOgSIerd0CYljn6mqXwUOK9pQsXnP6tkPdeQ7R5PDdYH0kUSX5WcCHo5h5f6KKHWmsAvT94Kpkd8g91Kl1lbVbUM/gTqsbK+N1ouOb2TAEoquKd9pOe7kHJutjG0Vf04WXphpJkWZjWeTZCRkf31LnsitjkdUm3FLkY1md9JvZUeLSVG74zJNWOInuyum7RjShe4lQ1GeKxG5k1pVV0mxXztxegQ2159Rus0F7kZnVszwxTfBk0HVDBifQNe7U+3BTVcSRSeGJM7PrhOQ4rEqDDZFrchONVsmbP0WrIYjJLhYlksUDJhFoJJagOkjXDkQ35SxqMFUAwq67k38naM+l2nm09dOTTCabMwtPLP3+8VhG8d9xNtdbG7wMd90vMf5ij5uqcAeRF4/yNgIKvbVKBGTmHX/HHHGnUNWkP8S2pwPXeJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On May 20, 2026 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> Several functions in selinuxfs.c allocate temporary buffers using
> __get_free_page() or get_zeroed_page().
> 
> These buffers are used either to store a string generated by snprintf() (in
> sel_make_bools()) or to copy data from user (sel_read_avc_hash_stats() and
> sel_read_sidtab_hash_stats()).
> 
> Such usage does not require struct page access and it is better to allocate
> these buffers with kzalloc()/kmalloc() that provide better scalability and
> more debugging possibilities.
> 
> Replace use of get_zeroed_page() with kzalloc() and usage of
> __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  security/selinux/selinuxfs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

I suspect if we look closer we can probably also trim some of those
allocations to less then a page, but that can be work for another day.

Merged into selinux/dev, thanks Mike.

--
paul-moore.com

