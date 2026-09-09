Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EDAC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEE06B0095; Wed,  9 Sep 2026 11:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38A56B009B; Wed,  9 Sep 2026 11:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F8A6B009D; Wed,  9 Sep 2026 11:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B62786B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:23:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17C4A120226
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:46 +0000 (UTC)
X-FDA: 85194593652.11.67D2735
Received: from mail-qv2-f8.google.com (mail-qv2-f8.google.com [74.125.230.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3854640011
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EbPsG0t1;
	spf=pass (imf07.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.136 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a49SZDeZdDlL0wb0CKipnoebXvB1XQTCDMiFWh6kHAw=;
	b=SH44bhRiL1gicrxCpk4GIz8kK/MJuVnJ1U0sha5bwwxEDbON8eOOg+xzjIW/57nKSTjTdY
	nOr9zQ7LbSSKexwguV39VOb/vou1X2a2jVGlH+GBlAHxAfpGXGxS/lOEao70BA86nFiaSC
	jx0pKKcdyPZCRKCkRMlfX9HFr/1sC84=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967424;
	b=XAqXMshP7IcuVh4ooLUTOs6+zZGdeO+XPQ1rNxTa21A6qL563KROjDXb06XdNUCY8zDDGM
	zOiYdxUY+aU4WltIHigwxkllXrFdVTzwJ6T5cm07BxgsN7NWKaIPeTWNQyoqRUFkkdJrTA
	nrBmJZ81DgBpLOxEvTLPJ5la1drywRA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EbPsG0t1;
	spf=pass (imf07.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.136 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f8.google.com with SMTP id 6a1803df08f44-91071ef28ebso670836d6.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967423; cv=none;
        d=google.com; s=arc-20260327;
        b=bZyNVizW1ODJ8yJSarnf5VdRlCcr27WGOr2QIwTTbNF9cQBCD6+0uM9iP+RFTfMNIe
         UC3xfO5wZTG17JmC8d97i1h8ZejZKvY24RuIF9yCmjYr3D1fbct+6QJtZBNI1SO8wE8l
         GuYTLwxWgYtRiaT3mc1BpEE+KeMIH4aIf+VkQK+sQNoSQq1IDTp+F3pfYjnJGG24nrty
         2+x06x3Un1R+56MiN1xCzRMNggILY1ORxxyTJ0gJY6GA1LanlGHeOkGE0Fnzr2hvjhBd
         SSg7w7GYFbcS+sP1fN8QBYUILFc1RkXeshFC4SYkqmnyc5nN80AlD8gUiK4HdUwlRMqa
         rvpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=a49SZDeZdDlL0wb0CKipnoebXvB1XQTCDMiFWh6kHAw=;
        fh=pNDzkkwNRldm0uO1dNTKYokkXlvntpa8yktY7JwmiJg=;
        b=sdN86d9ljtO5Z4IovEy/O5YXxG0xfj3F71AImDgHFz2JRviZsygfbTWsE+zaBjwRe2
         KJLGEQfF3ZmsK4AewRZJnoc8Kz0Jnsv1GlrqP9KRRgAwtcpaP0HiMwCPxnWgt9F6Mgub
         BQehHwJo2bvDFzvYyhW34VuReqEYfzWuHECZN0Kk48kWVCcEjQOaSqdanGHbktCmVt2k
         2XuuWnoZcfmHY1h3H8kMGNGC7SbxlerXxURpVUDhIhRzMHYS6gWwU9Ps1PNBdro1KVXq
         qs2j1oIweltLRlWO4IqEYxVQQhODB/OVda8IBi/ozsdQe9FofQxMwZ0LcOl0L+I3w0Yy
         a5tA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788967423; x=1789572223; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a49SZDeZdDlL0wb0CKipnoebXvB1XQTCDMiFWh6kHAw=;
        b=EbPsG0t1sp15kYjTlGUC+zAXrkjJS/z5692F17F7CitBonNQ1kDoMzZbbdO8mv3KcG
         1I19gkcDXw1j6yg79PuYHbdq1HXTLdJGM/1MnHcINrt0kMSSB1BqaPltiMSRh55VRpfS
         TFk2qlwf4ZvSS33DPEO8rAk/q9qEveOF+/dKKmPNK65v12jPbU3Hz2EDq9zcCE5mvwnU
         DStbMetK8qF3T3/LRhbk+mMdBkaSLT/tRIPr1jiyrjNK8Z6T88ogL3gSoNAn8ujPU3HM
         kkscvHmxYrTOOz/1/X23PhQjcqyk57SVywdh8J8cNV7iRp6ZfhOMk+MbguyJiMABEF62
         QRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967423; x=1789572223;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a49SZDeZdDlL0wb0CKipnoebXvB1XQTCDMiFWh6kHAw=;
        b=lSSecqAgBb/WrnduHtcnkrcUt/Pk9Nijj0gMgldGyg9AFwq4naTuyDy1UFsjL77XRu
         2i812lvkje/cTgN9faPv0/ehuTD958Ukl8W1dql/dQyMNR5J2BhKNIzj8ARvGYIDP5LU
         iciOzvAa/wWnEqB3oZAxP3NDaRCZQHXmrfVfjZzU/hckzoZMIxZO4oygoPfRD3oVY8GD
         8365va0EOaPL/5vgpQVrblx8RqeffLGF1d4PtlXyJ+ewsInuDYCpJE6qzWpWlr1qWl2/
         bjCAj8mW6dHb5C3zgXLXlugxAuQthGxryoGLRNwV7q660AX1hHpqp3UHomuS/JLSFlCN
         ZpXQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbFm0FZfrVJnVxWTekI66Wbe7xWfEYtqvHZ+5pxYMwhuQfdLRqPFvJLOagqlrkIzP31vjTXgAftg==@kvack.org
X-Gm-Message-State: AFuF++l+fGg69jHJCrAJDOIyPzVnZS8YE42QPZOeapaVqOcDjRzrvDUi
	DgMOwWGm/seBtZz0RIjbwS8MQEADW/W/PqB3H1F7aSkO5Ra6/Oq9uvT7tyqHqO0oDUicQiPzAec
	fmeXwslNmpdB7HaYlorzrRXssTg2xcEw=
X-Gm-Gg: AYBFou1qhmJSX+zCWppYtgmv+7DytEmFdefuSSdpBzgEVVWFl0krI8EIryfZDFHvf8B
	bho2XvmOx9o3WjQf9LhHBcNqJjN2XqYGCCuVnXu9SKFQWQlc8McT76bhmRcP7tLvoWl9SjR5ry3
	Qwwuypj/d0LfguhwC2A18GZhk2oZJTG1qdYHF/A5eU+/Jm+RUqpTIFToqSrTqUYtB1EKAEs0YPZ
	uTEZug0DKyMIuWsH+tnkiWu2NtQ+DSAq6O4SymIbEdSkVFDFe1ekTkzvHvS2Nk6pAtOQLA8gG6s
	leC3gOVeTkcKtFllCL0zaROVog0p7gzcFM8jZ+hEhzBSj4aRrvJRIQ==
X-Received: by 2002:a05:6214:8099:b0:911:2a7e:abbb with SMTP id
 6a1803df08f44-9112a7eabedmr11006266d6.14.1788967418682; Wed, 09 Sep 2026
 08:23:38 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:37 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:37 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
Date: Wed, 9 Sep 2026 08:23:37 -0700
X-Gm-Features: AcwNN1VV4AKxkj7aCdqQGI55bwKoeCFok0WoknLMsCk-ys-8GZWamlq1JVGaXEo
Message-ID: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
Subject: [PATCH RESEND v3 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rk7ufcgissoi7pt7rt39p1j1pmxbw89a
X-Rspamd-Queue-Id: 3854640011
X-HE-Tag: 1788967424-263985
X-HE-Meta: U2FsdGVkX1+mOd/pJF76IB5Rquzfz51/VYBDM/vQuUyEtqQN86K4AJnQKafuhGS6yMeWphbBumiqcqr0BzciVfBndHnu2ry9DZE25L98lbFWbdcnizooEAz8zZhsDMpANPzRyA/NEkY2Ygdgpe8rUwb6HI05snCWAujPwuq1EuBoLSEVhqI+8bL7Qs7vrtF9wp4/GE7IWIz+NMEk8exhqLVFFHOTXYy4Dfsg451WARSEw/rijVH7QUoQTjCL94in+AX+Dn076BDPT7d9LpIFduMM2euKAPeVdvXfZySA3hAUrMq9rkkqGhRTXEKB0CIlQctBMTrEuKj5xoipQmDHQG6efU1KIpXnSZsPQvlMxEgXm9Dk8iUMhfNf9zNbJ9n8xbNj8z+FaTn2fJPH16KccNar4tyiaooYaGlkCOcP1zNJPKrqugw+xcmwse9teg7fayyCjwfnMlonpgMcw21Mlxr+Ss5kWzxB7S7N2s4Oy0bwv/YLVwXcFpXEdLXacDVLU/hHf5uhYW+O/vHXcFGg1zLHepiPGy7tFWxiSFxQnEMDyF2PS/vSZ9QQ/tMI5qqPdZzUJXBnIRse8eopvf4OOBhwO9hO/8G2tdI34WJWv636JEBmDJ19rMsSAd6Tm3npz/w+jQYsDisycL71tcxzqTy3zFNnqQp+V3Z4qjwVfk5HgKU/C41esCcK+/1f+O3d22oVhJvAQIrZlwbBZoEgZ3XIkzOcwPujfOvEA2RPfWAXO+HdvZgLT204UGKk+NM8WKWF4q0bfPKE95bCBYZCFr7Q7LPA7TompzJL/2cOQX77xgjIfWSEeX7pQJSs8pAk5JOnDaY7XkVk9x2mSYIcYYlTO42WBHLlZlPTpli8jwTnjrDfUOwKyQWgHRlcoOLt7OEIuOl3odl2bMkfAPmWzuxjohlan1b4HCMGRbciRSq3/DwvxajY/KN2lLUllTHt2WQVqs8OqLEtIdekJIS
 S72adxFF
 uhq6dxTITyw6C1ogEAej44CbESQJxoecDh/+ywugCwWZtodhAJBaE0DOQcM7aBRfkEEVqiai27Tv3GfaaAXdOZTJwalaGG/JSbSOK1YF6JOAgi0ikWX7mwpGX+rZmEigBiMDZHUN/v0kyenvaX6dAbLpXB4zMZj61zykC49Vz9SqqSDn8zJCe+5xw59girQMMhsJ03W/5xwDBoBvzu8sq75HRj1AwEWdBc/FCV+0kGNpWX/nUlmI/Gvm8DEUF5Ncd22CnrYwrxxYxEvXfSy1YCXQicsYdOs025uqKiSMNL+fbnUuqprIGRgfxoVEY0Oo+m7fIFD53fEZaBES3BQBxR2nneKED0LQnZ91v4Cr7ZpT+0St1GRgCYwCaJTcBoNlke61++9uRIkmSvZtzXdvC4P5kBaUpmJyWgYKPFyWKQDTeG5rKsWq44WiFYHNlYWYuhlT+buHDYAURgbO1mBwjToSrQLtulUQyBffCWZ49QOB1jGl/wcD26QK/O9WiZyZOGJhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh can reach test setup after invalid options or category
selections. Its memfd_secret preparation can also change ptrace_scope
when that category was not selected.

Patch 1 rejects invalid selections before setup. Patch 2 gates
memfd_secret preparation on category selection and executable presence.

This replaces my earlier Gmail resend, whose outbound delivery wrapped
long lines and damaged patch whitespace. Thanks to David for reporting it.
The patches are unchanged and are attached as text/plain to preserve
their contents. I switched to Gmail because my previous address had
delivery problems.

Both patches remain based on mm-unstable b02c77c78ff7. The parser checks
and focused VM selection tests reported in the previous posting passed;
there are no code changes in this resend.

Changes in v3:
- Initialize VM_SELFTEST_ITEMS to "default" before getopts, as David
  suggested. Only -t changes the selection.
- Use Assisted-by: LLM in both patches.
- Carry David's Acked-by on patch 2, unchanged from v2.

Tianyi Chen (2):
  selftests/mm: Reject invalid test selections before running tests
  selftests/mm: Only prepare ptrace_scope when memfd_secret is selected

