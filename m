Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D194CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 07:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6CB8E0074; Fri, 22 Aug 2025 03:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67F38E0056; Fri, 22 Aug 2025 03:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57408E0074; Fri, 22 Aug 2025 03:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93F058E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:30:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1821EC05EF
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:30:22 +0000 (UTC)
X-FDA: 83803570284.04.02A95DB
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34B6D40010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:30:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nwp6/0MX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755847820; a=rsa-sha256;
	cv=none;
	b=FO3rRFvsWeyR/72QM9rifFzLiuIksKQt9/yahEJ/MRCYwPaFOzHnjBN5Q44OEuiIQQ2KGf
	dVTpXFzRRK+XcHOPv3m+rLFDwjhCCfV7+29F0ZjrlDHWsbQIZSGXkLvE0s9HS4ldthZR0y
	yd7ke4F8ieBgNBFCLiVwuAt5tDoN6+Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nwp6/0MX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755847820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+LKVPc9kKW7P+wvIba70K2T/PYJXPwn/uceRk+y08s=;
	b=ki4KE+EbiJdcdNAifseTglEHXHuJiGYI84bOV2H1fh7vGovWgNcD8YkZ0VfTebDLWlYaec
	esyfJCIwJDkrD1EB2CTEzz2/IL8aZK/P187avEKIs/v3d6CT8pGm2DZV6dPVDa7wioaZ5/
	zXQhyxb0v6u9Vjc9oF1WQLP30pTK3iY=
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-519d3c38bc9so527597137.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755847819; x=1756452619; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+LKVPc9kKW7P+wvIba70K2T/PYJXPwn/uceRk+y08s=;
        b=Nwp6/0MXmX/UnRtW2eYWpWXQ8bpCE2ZzEs7fRzvhmczt+S0O+utHMgIY2mbmX3mxx5
         W1xK4YUi6iDzoxIaB67ZsbJdKBlhAmMYuN4wjUMVRDtvFqqyOyy1O5FqRASNErtYpsPz
         nmQnPFec+yhnThnFi0qPDvLfBmMQqDOnu3Ilw4Jf+ataju0Pr5nLRD8LrBvFgMJRoEJv
         oE8X4J1g6EgN2Wc0+WjQeWLY6M6O3j66IxRAJYDR4d4SbTb9tWJeoGdB9Ax1lJV2DCxa
         SQHBYJS8n4AGk3ZLqckW++0bLqt4mwJ6uU0Wjr8xHceeE7BzPST4auqiB0W5BswAWc6O
         rtew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755847819; x=1756452619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+LKVPc9kKW7P+wvIba70K2T/PYJXPwn/uceRk+y08s=;
        b=sp6E13D8AaKqwjVJAXxxlazV9uMEnd3y3C+Q6W+0NJ79af1tB4LB69XfASl4nhrZaH
         XOB/NJxo7BNgYfC+ON1++EifCe2Kcyz6GO0EwNph9cQeJD5gKcSyFjyrLzqeXBqTkBw+
         Ea/y9qz+/YO29C9klp1hFuC+PnXpgvznLSYA/DpB31SzbqzF8s9CfCtpfkLY0n0TyY5S
         nWoPY60q3Mw1DpTTGBVN8k6O/CmsnoAPOMSF5lPNWkkHfySWBGeuPt12sX7UMafIwNQU
         vWKLdtI7gtt9UV6FefQUtbvmCx5exIRZh2NGzuCpE6r/gVeZve4iYxr7qwZj6gbgQErt
         WpGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3tWrG68n0XDNs25cvRb+kqow7+2g7Zq1ZQAv8hHjFylEvYiTX+Jz5P6V8uI9iLtrCjxQ7ttZcTg==@kvack.org
X-Gm-Message-State: AOJu0YyHkpta0B9SvoTCArxTnVWhcEixSrfa1XOB+j0xuYCWuvfQC109
	BlBNxV9Ryxitfra0wmLkVIIrAny7A2TcdOducGzQ4ewknkGCmGYDDxc7vul3M7si23XrJTEV0WB
	VkDKBTMKhwP/MEdFMHk3g6rC7JYet/+g=
X-Gm-Gg: ASbGncuy0z4eukd3XUNnobDBU8s4ZDLZgQ8WHAYQNyHUrkTjNjbFQQL5LFStHQ5vrRd
	fWm/rj3jtAiXg5QGlDVaZV010xo7AWcB6C/r+rfv3vK5bNN3jfUWfvahsT9rZAQ5YSgGMruLISB
	igtp0b6eqWmEc6OxALoZTHxsAl14uqZ/lx25ixBzT4tQjdqPabY+lxCZK6sYLees+aOW6+EV9jD
	UFu5w0=
X-Google-Smtp-Source: AGHT+IEtNwyUDOVJSiLdLX6NwOJBzlsyvEjMMa4jsxgGzjp5jPh2OUBTcyj8Lz5j55noj3cQHm2jQALdssibJnWImjI=
X-Received: by 2002:a05:6102:3e88:b0:4e7:db51:ea5d with SMTP id
 ada2fe7eead31-51d0cde2937mr458403137.6.1755847819116; Fri, 22 Aug 2025
 00:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
 <20250821213630.1771-1-sj@kernel.org> <CAGsJ_4xLKVM+1LqKzbwjd0vB_OYnb2E-h-Wb_C2bBxiSdU=3WA@mail.gmail.com>
 <aKgF_uJT99rBiyDd@gondor.apana.org.au>
In-Reply-To: <aKgF_uJT99rBiyDd@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 22 Aug 2025 15:30:07 +0800
X-Gm-Features: Ac12FXyv6CwezG7VPt_wlv2AiL1S_xRAYOxgC4WUz0F7iC1cnJ5iDPsKPK7KeYw
Message-ID: <CAGsJ_4xR3bvWTEfbu_navPHGiVacAJTY-87BvOH2QQd4xAM4VA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: SeongJae Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 34B6D40010
X-Stat-Signature: q5ruqtzwammfxofa5ug3ansq7yxhadk9
X-HE-Tag: 1755847820-815531
X-HE-Meta: U2FsdGVkX1+1l14+r7ndcoLB2iwJJzGDbRAG+hbYQVMNEXmT7kZj7T0zfsx6LFHHxV0Mdo+NbkjmceRV31sF9RkwbrQyebq55wtwV+VItcYoSudwezZP4FpTEC8GVw3I8CUmN+unBsu0ksdMlheqdPyhoWIgy6ZyEEDjsYf5zXB0/mSZnLmzQnlTJOJODVZY26M7zEz7ihjJQu0bGbcHmoLgctOU/zo+JomtJTvCMTglALNqmL3rMvir8R2LuXw/RXLgCjYk9EJ7zoSppcVWOSgVthtYmqOW4wHDU7ajt4E+ez8B2dvfkLTsGeNFUxgzUHPZKe+B6edREDqM2dvfIhwpVN5mIqerDIyL/TF4CZ5YXajY1n5liEj2X2ECL9MHx4MX99KQQ8QBuzO045XPrccxZbdJ/GdJX7dBKbZMea/HAoNC3LcXd2tXqTQc51ES4F7nnR3ju+waKte3wWfn6nltR3qPFSSEPa4vOTn7aAiXr0OozQXYHFHMFAa5BOk7zRWfKWI5anR9//95LwxZJrhiG6UhbKfsySopnTcmH7win6OhIpPnQlo4uL40K5Xe1lqUbvlrDeArzdbvGhuRUdyUaKuMzI+HMPrzpry5WEzkGuFpiRKkUhczjEYxNBVhNU6HWdsMKrLDsLvTZSdtilRxnHAxmgRydiM/dF9nsUUrDgdiDHaOlzlpBIdTAo52YVeuFe1bby1jdMAjbLNo/9AvbjTe8+MCOiQoK3wlvYnH8vAFClOAXomBSPG+5wF/6E2zjR5qiX0mCi/MeT3QbGaZsiMFU/ioBX6JqZoc2cRs13pxw6kEd8euspvHz+DSRa8kiG2OHurO+yDduLivp47nuPfhhWYBgqbI6AGPXB3hVQFUd2lcJhuAXLDDnzm56RhoTM6QflbYKOctpeZUTuyZ2ZvW/+fj7qKQhBUj5x6XCY70LtbeeHDkew8jbF6Oi6uOWXeqYGgrFqNpbC3
 vJYY50UV
 wMpe9udMWm0kUn6s3iNV9sov1/mBqGYzvY3H7rjRCGrloyvl826dJ/yU3VZAS63mAu/38XM8pipn9tKx3ACNC6PYPI3jFjkly1Z76g1uvCSeJ/kBx6oj0rDlRb2JF9B0JiWIEcBP67yORRXySPoLJt7W0g76BvULRvGvkAYNB5ZPE0YS4STZ+mJQJ9T9gTMLFFDxqU0w1c7qL4GWNLb3O9NNeTt283YE4glnwBh7Gxh6MQ8XpbVIhvVvnjrUuyaQNLYhY3WYVLbKcrjAuotuhNWQRfLgjx3e8/pt6u0o2CUEPXWDN0+JogYtpHky3DJZ053u46yy9CqYxzQFHWCZlN2N4ZCQCy3E7tAbBCWY7U8c1ihyvDWQLuiESyVWE0j/0av9ZSO+/cGl6Fa45EJfbRg3gdn2c/JmzlRjPhCgXpcKx76swDdovaw0hxnliTit5Q8oS7Opvo5CmamsYYHaoLf9gsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 1:54=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Aug 22, 2025 at 12:48:27PM +1200, Barry Song wrote:
> >
> > Is it even possible for crypto_wait_req() to return -EINPROGRESS, since
> > crypto_req_done() will not call complete(&wait->completion) in that cas=
e at
> > all?
>
> Of course crypto_wait_req cannot return -EINPROGRESS.  However,
> I was responding to a request to make the crypto_acomp_compress
> call return a boolean instead of an error code.  That is not
> possible because it has to be able to return -EINPROGRESS.
>
> Nor is it possible to change crypto_wait_req to be boolean since
> other Crypto API operations (including decompression) can indeed
> fail.
>

Ok. zswap only cares about the return value of crypto_wait_req(),
not crypto_acomp_compress(). So it=E2=80=99s clear now=E2=80=94any error re=
turn
means the page is incompressible.

Thanks
Barry

