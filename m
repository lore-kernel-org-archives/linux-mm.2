Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD746606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cb11HATF
Received: by kanga.kvack.org (Postfix)
	id D313D6B00EF; Mon,  9 Nov 2026 19:11:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08CB6B05B0; Mon,  9 Nov 2026 19:11:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21D56B05B1; Mon,  9 Nov 2026 19:11:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F22A6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:11:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D0C21207A3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:11:36 +0000 (UTC)
X-FDA: 85417280592.06.D528007
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E2BC18000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:11:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cb11HATF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of "SRS0=JkFz=I7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JkFz=I7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794269495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wECulbhH+/PYIsAouc/0+vQU/WPYaJWlZhevaQ1pdgA=;
	b=QNXPk6Qbg1l7C28co10gWada/E7AAbFruY7GngP6Xt7Hhf0aS2kAZbEP5HJoHnTUhIsAWA
	pYZdj4mqyKsRkE1TqFwMxbHRFj8A5bs/4M91sUOT5rU1+hYhwNlXH6Gu0AGi81Vwls/9eN
	ZVGpoXNhepQ1F9aQOW7tdEIdNy3MKxI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cb11HATF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of "SRS0=JkFz=I7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JkFz=I7=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794269495;
	b=zn2q9NKludAHw1B94Rt0nnhxLd01uKKtVJa8ptFqVQAF6i+/WFhqcuFMh4osm9cGPlEcyz
	maEnLMTNszpIpOcbBvFAC5oHtFE1Lay+Di7zWvGwkh5GPibsvAjKXEkRsNcjJ4oZWRDQLQ
	qyTK4cyp72MBKTvlSmxqyVfcPSe1Lsg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5678361380;
	Tue, 10 Nov 2026 00:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A81B1F0089F;
	Tue, 10 Nov 2026 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269494;
	bh=wECulbhH+/PYIsAouc/0+vQU/WPYaJWlZhevaQ1pdgA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Cb11HATF1t1c/JnWLzbX6q9oYoGbypkpkFMthwSuWR+x8rBlzHhwryRtY2/TCQ/am
	 PWNp6x3m4Dawulyjak75YF9ctzy8tE5ve6hU8Z1Q2XmQt/TVE7lSteiqVyLNjaG0mc
	 3uwDwEtOPUoZW/uL2/Wp95gOWl764BeFa/DG2TgVNnJ0mbA0ERGtLPVRieIDR/V64I
	 yD8JNl2r5ZhHb4sZr4VSqWOhEJR4Ci/YHinqAVFTT+DjkmHIqbRwN3QWkil4rZ8BGv
	 mz/swpIZRaSnYXiz7cfBUTin63uzSNtQnNEk5D6WywfoIY7bXy1BGupJyiDfUmeF+N
	 qQpbh8OflLx+w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id BEE6CCE0C97; Mon,  9 Nov 2026 16:11:33 -0800 (PST)
Date: Mon, 9 Nov 2026 16:11:33 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, rcu@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/5] kasan: Avoid an unrelated RCU warning in the
 callback test
Message-ID: <c333cb25-d007-4a0c-a8d8-86187c67d747@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20261109000243.3936824-1-joelagnelf@nvidia.com>
 <20261109000243.3936824-5-joelagnelf@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109000243.3936824-5-joelagnelf@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2BC18000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 35xyjpbrshx9wneqbynxea64mdki967u
X-HE-Tag: 1794269494-844297
X-HE-Meta: U2FsdGVkX19yK8HscxU+H17qTlOsFQV3S5kvo6+MjYd1WpWsfFSsppHZJ9tvIyBlDdyNDVr3mvCOAgXH8HcQ+WCIVboV3DElOpAfjWPatw4ru/jBbofpfimvdAtDLRZ4dTNRiR2XvZNRj6pLWQN9iA+7Umng/aptfDnSWPen8Ics/R+LlvDhZd7FK+s5StRIouACHvszSXLkitV+d96KySBCe4kMLTNh19HM2Jx7Gd+dmqd/9LIxBKakfivS36QJWyD7eXnW5VbSixxV0kSZuu0HtFDjlMP0E/UqcJBZxyQJLfpYHUt32MWrzIb83BOFBDEgHDmxAmSWGcMD73n6IvlTeyYRYwdMDTYF/OSPVt+R3iX6HzoHZFr2ABm8PDxP52rUEVcDOK69dHMAEWk+C8yHOgRXPKyg/rvIvhtG3WlRHfGEi27/0LM9P3JdieO7hkpq1W5auEBFf4S8xaxiamehnL083wLimTVQhk7MAhMj7wDYM586GXC2zuU6F43cuGltd7tYxmIg+cbuWZ73RWzemFJNpTzdKBnXOk7hRMMXTHH1dAIHFTjxEWOeymevwICqr0c1ZDdge1nhZihThoDOa0k4PIhLeRKF7hG8i+XDrZu80uPh8Z/1rMiYTKUxDBxVaQYpjINGyyuuZ+ud2sbCJyIhF/fNiZfApxumlkBFmjkwJPAr6D/DHqThJKcB0yRFgDBCakOX85kIIPz1xs7IWOblQ7hLUgQS4ybLZFERRH1rfYsHzdvlg2Me2tWpdM/3cSXLtdHjvv1vNQEukIJsCvsOsGTjwkWkG2SylXVFZLLeQbuQxxIX05otBsjH0Y8G+7RAIP1QGWWWNzuAQOUb3dKYshKX4sTRLPNBXJgzJWtwI+3C2ly+mwGlj6eWyaB7+OwJV/9rM+JmB1l2I9g6Lm4gpS1H/noEpkUT6osS7/rDRr5AK/yC0FYHxpvna+GbZUVz1VB8PZs0ym/
 QuP/9UzO
 WyQqGPKCqgSh8j+Tz3/st4WYiy5IaZ4J8RM9XpzkaeoOGpx0SvGf6nJE6DV6Fl/+ViIOW4HkZspthGMdBYaXWZuFT6fm4YatJYaMQVQGRCaqAumVWxY7b5JZBbEBB1nwMN9kWOvVm1/3kMoUB+aaWk3/WGbNdOBqKlfiq2LEVVXqKoCOEOfahPBsyDmXcEZDtukTnrzgPxZq2A5NcSgtLsgjIRs6GNttIE1l6Xh6zuDQQzmBfjztirV2CpBu8jsC7OlM7w79ldYtGxoJzhkxyuK0hzRQGnYnJaiZNvmOxdpTguNYtfPEvDklwUFntzgvUnASraYjCHSKsNq/AqhiUM8PF3146FB5W50hfPFCrMQLMIclG3LTORcgA2qsdtGXP87zN8qGg8f/gbILDItjG0l3e5Ch9162MURD3pVGuhyHii8tvcexl7I6zJsOhZ1fINPdcfME5Ew6Tlk1sc3/V/eWGolCSfwk24HiGbc2IrgU52cGpm7t62oQ8+l7CEq4IocsZxyh8p9hsQX4ozlAxNowfwZZAQ9Q0wD8ES8+TkJoL25+v4gIIEkNQOEc5YbQOP/4HUwEEcpkpAWYGqA3z/SaL5QZBSOWi02txew3QCA/uwOrG7GUzCEuKtyFlV7u8KL0+rO9ry0m690EoAaKtUopw8FzRoeA4me/xZcJjo/9NxhweuaHizI2qyvcW8VCiLFkvpCH8uTnQsIdls5fCsfos5Il1s8rVIVMa7hwbAIVrBorb53NyXBPYas0XBN5ijuzGhZc5YepbbTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 07:02:40PM -0500, Joel Fernandes wrote:
> rcu_uaf() passes a false protection condition to
> rcu_dereference_protected(), which produces a suspicious-RCU-usage
> warning before the intended KASAN failure occurs.
> 
> The pointer refers to a fresh allocation that has not been published to
> readers. State that protection condition explicitly, leaving the intended
> tests intact.
> 
> Test:
> Built with CONFIG_KASAN_KUNIT_TEST=m
> Booted Qemu guest (8 CPUs), ran modprobe kasan_test filtered to kasan.*rcu_uaf*
> 
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

And yes, the second argument to rcu_dereference_protected() is a boolean,
not a pointer.  Good catch!

> ---
>  mm/kasan/kasan_test_c.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index b9e167ed5be3..4e23765d722c 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -967,8 +967,9 @@ static void rcu_uaf(struct kunit *test)
>  	ptr = kmalloc_obj(struct kasan_rcu_info);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>  
> +	/* The freshly allocated object has not been published to readers. */
>  	global_rcu_ptr = rcu_dereference_protected(
> -				(struct kasan_rcu_info __rcu *)ptr, NULL);
> +				(struct kasan_rcu_info __rcu *)ptr, true);
>  
>  	KUNIT_EXPECT_KASAN_FAIL_READ(test,
>  			call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> -- 
> 2.54.0
> 
> 

