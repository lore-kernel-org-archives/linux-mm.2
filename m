Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABB7C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899876B0088; Fri, 28 Aug 2026 13:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AA76B008A; Fri, 28 Aug 2026 13:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738936B008C; Fri, 28 Aug 2026 13:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABD86B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:42:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC03314052D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:42:48 +0000 (UTC)
X-FDA: 85151398416.09.CE08981
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74712A0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:42:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gvktQbOl;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787938966;
	b=wska3mul6oxsk2jbeN3AMJ1ArdkcWlwPvLBHY0vy1k2U+8DF7WsaDZYJgc8GZvhw2LJgfR
	0ERKQnn2Hn9cK/wcqFmGLLx96gWvsxYdxrxW4c3CBLBr5tx5sNyiaaI/ET2liU/SI8LKuE
	Gqn8a1ZyAqqgEsMrG8/jyJP2u0wnqng=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gvktQbOl;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787938966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GL2lsY2q6lh+Mh9KUYPYp0RjapCsGo7cY5qRZTg2oBA=;
	b=dj1PwmspVfkjE3NnvpW9UfnLcYF/6HGPngxepdXOSo+c4Rlav3NhKUod6dwxgMocFhXqII
	vXh2OWkTH7C4I9JueLMMeBHysp95w7YI4rQDBHJWryopG1HGZsmnCpsOiLJw/hi+x/ovUj
	twmsp6X0B/Nbl44NYeR5APp12rMxcyg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2055573c8cso153987966b.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787938965; x=1788543765; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GL2lsY2q6lh+Mh9KUYPYp0RjapCsGo7cY5qRZTg2oBA=;
        b=gvktQbOlDR2DU+qnxevOEPnStlPaXnbXu4SihVf6PHhIuPg+tQ07WSftjzhIgSTjYC
         zNw20GmbEsWpHTSorJKlXZMgboF4/x5QL+7nME8YDBfCLmCeg6jtgZfX8UpVDYE+k8Lf
         OyH8lqjDTeEYwh6lXad0w+PP7ap2OfVmikk2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787938965; x=1788543765;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GL2lsY2q6lh+Mh9KUYPYp0RjapCsGo7cY5qRZTg2oBA=;
        b=gzpBdhRvEFSbYjlOykPNIxkmQTpO+mpzj5wF8w1lH5oWwmZ5fqbdgYjxolszg/dqmz
         VLrL8XYz5Oj0Znu4Je5Vr8f1ZSEMS3UTQmVZFhJMm9yd7kV3AjErdrcsyzXf/yxHKi02
         Zos1KQTbEN5dF4uhuR1Pf689VbHvj1tQ3c8x6Vm34NbSJ6Ap6v/7UyjMlSJrWt0a9Bb+
         z6oIGgULgP9nREbRB0fF3nePotag1OQGOdkU3QjcgHTPYl2v3Z2C1kPra0hJhFgEj1z9
         Q4P/m9zhGLjy3+BWD6GYxEN5rNby9u4ImycpQI6htnzETkLKrade11HNNQA3E1ZZYfzR
         vrbw==
X-Forwarded-Encrypted: i=1; AHgh+Rpwx5yfgYCn9mJYg5HbVSPvCnPv9mL8hwk5nr/PWvIV3aDQjvDCaYjjeonk5HtZTCy8EJDn+8a+Rw==@kvack.org
X-Gm-Message-State: AFuF++m7465VjVP+hEwYlMLwNEIUuQxGs4ErmkvwQ8uaZjTFVGkvYmcZ
	RuaZivJmmx6CZp2858yZ04A11PG7lb9e59BCi73TQccffnLXLKH6dxLvkbn2NqfhmCQSlbqm1J2
	zA/i86SY=
X-Gm-Gg: AR+sD11nDDEkO0cT4TKmF0Ou99NRWynCU2CHiUlrr9TOqHNOFSWu5eONd5E089RGJm3
	V/ZUFy+iAc6bblSEG02lkb5aFlepzAhy+3SlxqETx+xPge9aHaEVnJAT31e7FhLrgSZjnYtJjWP
	tPuTJ/q4WItdXxFDBcjELRrTzryPbrHGU7e4ka7YqZGLyR4PutWx8VsYJ/OtEav+JH0kzdhDI3F
	oLr9GsHnD3LHdHquclrdtdoBMnZzYQHbZwyDblX48vID9lnQetoDTDHWUGZaGcxyfvsqvHS7Vs0
	v65hLNsRNjYlktlByr3X5YCTRZDzbA927mGZFCNA/Hm2OgOppInvxaPas9P4JHDohW3yVDflw6U
	T6ypXJvVbos6aJ9KemOENjkILuESKL++PsSz485LGiWzEhi4vxSsTEZo1M2j+zOITmxm/y53sjM
	wGgKXVLLOb+LoIHCWklWhQr5bJLb/7QwAYtn4bl+5WtBAZ5pgnyleUMU3Wf0u0j7D4yd+pN8U4e
	yZqxw92UfJrfnv9z4yxHCvbiDEX15IpfpIi/g==
X-Received: by 2002:a17:906:7947:b0:c25:4ba1:5953 with SMTP id a640c23a62f3a-c255702dfb5mr645442266b.11.1787938964866;
        Fri, 28 Aug 2026 10:42:44 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255ee09e29sm112543966b.3.2026.08.28.10.42.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 10:42:44 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c25344a8c6cso156175066b.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:42:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqtl86vVPu+iU1UFZMlH8UYVSaq4wch6e2WsbssiFqxqMUrcNhGxOTrTEvWuqpcR+2T8PyTHW3zRg==@kvack.org
X-Received: by 2002:a17:906:7947:b0:c25:4ba1:5953 with SMTP id
 a640c23a62f3a-c255702dfb5mr645433766b.11.1787938963933; Fri, 28 Aug 2026
 10:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <apG8g-5krNRUFUuD@casper.infradead.org> <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
 <apHC_mHJ3wsJPEgy@casper.infradead.org> <CAHk-=wimz+APb9hGEry+vHDLB5D7WZvNGWU89HjGw7wH15KGHg@mail.gmail.com>
 <apHGdfwY67YZ4sEr@casper.infradead.org>
In-Reply-To: <apHGdfwY67YZ4sEr@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2026 10:42:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgrY29fKgVkjjs1TfpR3y-TNCF4hZ9zqsbBGSMc9BvHYw@mail.gmail.com>
X-Gm-Features: AcwNN1XMk0tn5kToNoPohLIAPg_QHNiusV8BkGpX280Il2RW44EB8ONqq3geRJ4
Message-ID: <CAHk-=wgrY29fKgVkjjs1TfpR3y-TNCF4hZ9zqsbBGSMc9BvHYw@mail.gmail.com>
Subject: Re: [GIT PULL] Remove dependencies on pagemap.h
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74712A0006
X-Stat-Signature: geg4dsux389rcyo87xfexkiky58pb13u
X-Rspam-User: 
X-HE-Tag: 1787938966-855402
X-HE-Meta: U2FsdGVkX1+fGXBx/23gXYjg3YvpZG1ox9oNefSbCkIpTeec/hnKLOeN6XWYNyyxlXfprG54aHAXCl/pl7LbYFphNnJYlP3u2URfCjsLFLBhJBEHyELjIvIdsSs7D5Y2QGb/yCPNwJtfcoUprNjwLoKHkFKRsct1clykV5Vy1OItzAMgf/T1nCms4uM0DMDPKRIJQeYJq/i5d14M3bXXkWnSwMsRMEKEF6qzUCieuqMKy7sPc9eAQ5Sn2toHa8pQ+w/7Ddw44ESbC0XFdeI0qBec/OwKSS1xnP6k5v0czm0MQPRKb2EjAT7Ccn1qzIE1c7PvGw390D3RzVI1gKBjRaTatLt5dAYT/yfSdz9eMrqsUnjGn4BauYPejKidnkbXek8Co2fsK6UlEH+1ILJPAM2ga4CAI+9+whqaSblp5/tq/x1bEPK4FIbrz7Jo0xvPxYe7K9kLTs4umYyb3TeiwEMhDcxAAoud562Q2bPre8tXnoYfSihqNb3izT6qWfsrmcDZ5qiTQ4a9S1DF2dKA2dhSvJyXoQcLIDlieUi8KlUKlLoA3qJ06DQbt32md/fCjPXcWSXxQYx8lel8OrOEFEAXcCICCBN3/xNeuXd+pcaBmjFHz2rwPcaOFciWwQrgj5v4MQf6fq0Zb7ly5GGNS3V3l9yy2OQ7d3AOrHSF/m+2YriIWZXCIznNpkJnV4T3HfMv47zy0XFQx0FA7bklRRPc+k0xVnJwKiMDNcR/Kc/ItsvThsssjM8RV+CkUO5Adn4aRoExhw1q4qDG6MMUsKjgKbeqUIHK5HIR0AJ8kNC7UQbbPC0oBC/eM9zQptzFiabWFEOM0dO6YZ5UKZ1NIq33V1rgWMCXvJdvG7+cIv07Oy5gCRXOb51gKPEs7kHiAl3WAc8Bvdy3LJcZ0YmryJqkHWeDODO4Kf4TW0ljONRdTe/BncAIg/O/k59EB5pQQkLTbdYwjJtF8BgePUX
 HjyIERaD
 78Y9IdY9HUqiOBNsK4sFw7j6wB1kxD+xcfZf/cjbKx276/1tG5yH0MvD7WEawzUhgZzaNCMkoCuWHBNUWko4q53edYMLzKZayxb0mlWmAhh55Oo/iaATrytw51AkJnXsjEtGZ4/QODp+4nw8NNtHqvwyhTQ8nxL5P2rNcd9WOlsmHwo823BD5jlx023VBmsmFlv8fDSieg5fcBqMwnfHJj4gZ8gFatBOJFgAdv9QmyJyEmOO7ywMyy34Yz+WN2JLGrxdG3ui7+qSOU/PiE2I+Vbl5XFZqv/aB6QoLl7Yj4YfcE13wq1/TNQN6UW+3mOTZQ2FplzMiUWOlIOXFIa+eQGJ6K+nsZJIwbolFFGk8lf4YKZytMOcZ+F4zqAj37gxsaqB/9nsI9s3yGTVzW2dwWY3N931YGqQZzyj6iC7OwwIj3cepNdxAmVFQtDax88cbXaleNa0ikH2X1Bf56QcfIp9ZZAVDclddF4435NfRLC8phBA7xEdhbHZ2QLU11u6vUvgX3DkSi9W4/1gv7ECov7K1NxT16nDjnqI80/ijaMN/JtYexkbyWOITDgUybr2NGnPT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 at 10:33, Matthew Wilcox <willy@infradead.org> wrote:
>
> How far in advance do you want to know about it?  Because I did send you
> email about it a few days ago; must've got lost.  It has been in
> linux-next for a few days (would have been longer, but the Intel test
> robot kept finding random drivers and configs that had build problems).
> It's already generating conflicts with other header file changes, and
> that's just going to be amplified throughout a whole development cycle.

So basically things like this need to be ready before the merge window.

During the merge window, I basically only read pull requests. Sure, I
read other emails, but it's a back seat operation at that point.

And I fetch linux-next the first week of the merge window. Anything
that isn't there at that point doesn't count as having been in
linux-next to me.

In fact, I should fetch linux-next *before* the merge window even
starts, but typically I never actually remember to do that, so I only
fetch it the first time I go "has this been in linux-next".

And honestly, none of the patches I saw actually seem to merit any
kind of special treatment. "Generates conflicts" is not a huge issue -
not for me, and not for linux-next - when it's trivial one-liners and
no actual code involved.

So put it in linux-next. Use a signed tag. Make a proper pull request
next time around.

             Linus

