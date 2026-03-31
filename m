Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86EA1061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB51A6B009D; Tue, 31 Mar 2026 06:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BF86B009E; Tue, 31 Mar 2026 06:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1BC6B009F; Tue, 31 Mar 2026 06:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4C036B009D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:32:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82359140CBF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:32:06 +0000 (UTC)
X-FDA: 84605993052.16.7CC1035
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3D0B100010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:32:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KRppocxj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774953124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTf6t+shlozTTQQAsguxmrn4VBcayi2Dg3j1XGQX/Rk=;
	b=KFazXCAAGZ9qUyAE6JzXCa4HLchz28gi+leshQFR8CBQ0MzdnYIlaE4HVRQN5UHUVLTXMW
	ZDwJNh8rjI4Ncf+rNc7fHhmU0r9Bz7ERSVzsT3NdxsjCANbZ/yXK02sGNbeU66/FK66u3U
	aOWvgkHKpJ8MOaREuUC835nhTD1mM8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774953124; a=rsa-sha256;
	cv=none;
	b=1nrQFLZDtsS06YyoamCOJxc7WhIEIQO4VC04CzNnPBET/PspFJnvmJlaIIRGiUoohXbD9q
	tDF/lwRBco+SBvtloIV8/CckOsMYHWiIobzaCXGhl16AlOeKQL3wGSK/usAbneUsPWXedr
	TvPf5qqpmhftIwQC1NLxAibC8j96QXE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KRppocxj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774953123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JTf6t+shlozTTQQAsguxmrn4VBcayi2Dg3j1XGQX/Rk=;
	b=KRppocxjRi2jDTaTM1qiyxxMvBs+GnL1UVTluSDpd1B6zi3vUt0e/LbmnZe/oBJkqh0wI6
	GW+e6BGcD9zt4sBc1MPfbxaO6AczROgpaPy4FOzSMOdyuWb3TOktIr2W73Or16F1VX2Th+
	qedVDNcp6rRMOM8Hohd54oLM78bj9Ho=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-mbOYWH3SM9SW50Io4JD4HQ-1; Tue,
 31 Mar 2026 06:31:59 -0400
X-MC-Unique: mbOYWH3SM9SW50Io4JD4HQ-1
X-Mimecast-MFC-AGG-ID: mbOYWH3SM9SW50Io4JD4HQ_1774953117
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CF541954AC2;
	Tue, 31 Mar 2026 10:31:56 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5977B1954102;
	Tue, 31 Mar 2026 10:31:46 +0000 (UTC)
Date: Tue, 31 Mar 2026 18:31:42 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <acuijiUs81Z7qYSL@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260330151503.670415-5-chuhu@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: rjJaoerCTrhCisn3lftBcrKJr8ebz24SrCy5iiINOso_1774953117
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C3D0B100010
X-Stat-Signature: abam6zcfme3wod484c7tyhf1ryaaonxe
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774953123-980635
X-HE-Meta: U2FsdGVkX1+G1bR4mx9O8h1vMeICN75yfZimD5U48fdgIDgvu0fr3QDdoQyntSAVsgt548ydxma4335JGCSGQkMqFaDjVFdZDQPKJBIj5P3+FrcUjyglrZsa2Z8mIMTApwjkQuOKDQorEmtfYaeF4SZaxxWeQoXp2A9pmUZ13t0tSag6iHmh9eIBVrMgQekLsYaD6jJj+K94aJQRidbvU9vL46usoiVskq4gNAOjyYSnthMG6UO1KmIsH3izd/cXkp9XdX/CfbZImfBNc5jRy7dJ743qMCwDqmDzTNB5/in5IqMQlJtdJRdZW+P4CUHiJJ93c9bk0yKYCsKjQaK7sAQTU+vCSuFlaPGtI3gqYs3atTa7ZZMpRcSytCCwA3+YoreBisWrJhba5CLA4KNwlb3FkegL8UzjjeAe8YcsSOXwGrygGDBovMOO7JiSnsn/VKTFdpwSjX6ELRvzMjkjVmOfQlPPR4wOaaOQKOMGjGcBJ6GsLO9rQpuVc2Nh1H36lOZm74aOCDwvyZbGDBPgJwSlbHbqUJ+PoKeApwrRbeE9k9m7BgmCjvJQ+hU+1xLYwptSumKWkpXyVGYbHpywj/7uzMdEDOW5H2Af8PcaBEX3SwqWr03Hv8BhCBL7JGmZkcMsF8QSYMLTI8Uhzt+xB5b5tS2BHfipb+AhIq0r1OIorXDnt7oSPgChbP/R1s4SmvwpskaMtd18S7dgPswEquKHraQFuRgswWLOuxnpdvTzZsC53gUC/IpYjq2v9TQaeK41V5fiqIjhEPqGH+knEJovDHOaqZlqdZOilx8oA2TV80ZjtMW2z3MuGNJednqwuY1zYqIYIu5XzN06zEfF7mjV3CRaH+t82yNd9M8dgo9E6dzbuNwVH+OrWeb8MKSONvajvwVQPT8MqNv03BifTQsfyVFve4V51jmT8R14oHtvEu5z+4AoCRNO/suBFWQviPQr7nmTX7Ypw8gJ3ec
 aaUqOE7I
 NPOZvgK2qxUfzP7A+4eAy18q5bB7CEsWQnaUgbxDXkjapV1y3CjFsq7ESLqJmQk/YZcFvq0JIc+11xiOD5bRhav/vyy6nKhMDgBgikfUZOyR8bRrSprskcM9W+kFbnbO6j5+hGqLzRCygbFgARwUi2NO5R1cnXn9qIdjH/dlbLtfWvuwYjdvTvvW1mf5SE+0dAMw2dNPpcojzISM6mrO+M5vr8kNOBJfrULUv8uhAv8oc+UEqOJHw99Was88KaEFzvc7Y66DBUvKi2C0syN0Lzr/0NkMsc07WQL8LWXS7nv11wcwe3TNq1U/aRZO9IMm+VrV65NfzAhgRpqVYMFL/A8NwqZEuTafUhqm/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 11:15:00PM +0800, Chunyu Hu wrote:
> The ksft_exit_fail_perror function previously only accepted a single string
> argument, which limited its flexibility for providing specific context to
> failure messages.
> 
> This change updates ksft_exit_fail_perror to support variable arguments,
> similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
> compile-time checking for format string correctness.
> 
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v7:
>   - new patch to convert ksft_exit_fail_perror support variable arguments
> ---
>  tools/testing/selftests/kselftest.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> index afbcf8412ae5..11cabdabb3f6 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -43,7 +43,7 @@
>   * the program is aborting before finishing all tests):
>   *
>   *    ksft_exit_fail_msg(fmt, ...);
> - *    ksft_exit_fail_perror(msg);
> + *    ksft_exit_fail_perror(fmt, ...);
>   *
>   */
>  #ifndef __KSELFTEST_H
> @@ -417,9 +417,24 @@ static inline __noreturn __printf(1, 2) void ksft_exit_fail_msg(const char *msg,
>  	exit(KSFT_FAIL);
>  }
>  
> -static inline __noreturn void ksft_exit_fail_perror(const char *msg)
> +static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
>  {
> -	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
> +	va_list args;
> +	char *buf = NULL;
> +	int saved_errno = errno;
> +
> +	va_start(args, msg);
> +	if (vasprintf(&buf, msg, args) == -1) {

kernel test robot reported compile error on this, as the vasprintf
required _GNU_SOURCE. Looks like it's not appropriate to be used
in the common header. Looks like it can be replaced with a buf and
vsnprintf instead.

    char buf[512];
	va_start(args, msg);
	vsnprintf(buf, sizeof(buf), msg, args);

```
   In file included from za-fork.c:12:
   ../../kselftest.h: In function 'ksft_exit_fail_perror':
>> ../../kselftest.h:427:13: error: implicit declaration of function 'vasprintf'; did you mean 'vsprintf'? [-Wimplicit-function-declaration]
     427 |         if (vasprintf(&buf, msg, args) == -1) {
         |             ^~~~~~~~~
         |             vsprintf
--
   In file included from basic-gcs.c:16:
   tools/testing/selftests/kselftest.h: In function 'ksft_exit_fail_perror':
>> tools/testing/selftests/kselftest.h:427:13: error: implicit declaration of function 'vasprintf'; did you mean 'vsprintf'? [-Wimplicit-function-declaration]
     427 |         if (vasprintf(&buf, msg, args) == -1) {
         |             ^~~~~~~~~
         |             vsprintf
```



> +		va_end(args);
> +		ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
> +				saved_errno);
> +	}
> +	va_end(args);
> +
> +	errno = saved_errno;
> +	ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
> +
> +	free(buf);
>  }
>  
>  static inline __noreturn void ksft_exit_xfail(void)
> -- 
> 2.53.0
> 


