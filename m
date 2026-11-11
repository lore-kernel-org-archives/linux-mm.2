Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB66F606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XiFtxNio
Received: by kanga.kvack.org (Postfix)
	id 1B4966B05B5; Wed, 11 Nov 2026 02:40:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CBC6B05B6; Wed, 11 Nov 2026 02:40:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5B66B05B7; Wed, 11 Nov 2026 02:40:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC9746B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:40:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 748721401EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:40:19 +0000 (UTC)
X-FDA: 85422040158.15.CBCAF6B
Received: from mail-pi2-f10.google.com (mail-pi2-f10.google.com [74.125.227.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8538B180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:40:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XiFtxNio;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794382817;
	b=BZ1zEoIqcdw2DtjghPKt3vcVjmNbbzZV6BK4tqudLQWWxzuBsZjSFs9gCnYIH04zk+gkfw
	N6oV7xuIsaJE3XpqN22bmOQKQVrKZgivKYcpEHeiOxhudJb7Q4OnSkDxDP2QCS3gGPKwoA
	equwLeM/RVAazyZah/YipkR09J24OL8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XiFtxNio;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sA/bJ7zlvzB4PjwB/BzIEOEcwq2h4lfsdHKluSnl6M=;
	b=RdfcvRGdl5+ewWPl8lxCfg0lZBcovjRCPCBBp8fTxSF6vNmAKVnrCml12/iTsScrRXS0/k
	a2umlCoypkIg9XfIzjx/NryV5JKlQeRHPCHM/TzEjJcRsBnUytUIU5aOMK+3KnVN9S8Fd5
	EteIMZJNMI+Bz2+sQtUGbXTjF6y4N8c=
Received: by mail-pi2-f10.google.com with SMTP id 41be03b00d2f7-cd6b195dd0cso750250a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794382816; x=1794987616; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5sA/bJ7zlvzB4PjwB/BzIEOEcwq2h4lfsdHKluSnl6M=;
        b=XiFtxNiokRkQ0dU9XFDv9Fff83rwLwG5UdoSBFmd4NacoGAd5UQUBdk+brvoVOz5xE
         SayINdiam3QWn9otBATGzUZ1RFTthNNqG9CaLlx9M/RTdcCisvwqeEr4E6ew0QdkckLz
         nqUEYpgcmbDtqMNKfiR9vKMWrJuGioy4cBZVV2qYew+E/x05I6oV6Sc6tjFnxEQ/Trjy
         jVaaxdNf35NvCMO/iVvT446YGJDPmpgQMYt8cc475NrPoaQhnq32a0GdzlZxrpZ4DW+D
         iq+bdBmsGFqNvuTgUYwU4YQmNVFngsUwHKuocBW2XRWCneMIuhyBAsPXwM3AnorGZb/I
         moCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794382816; x=1794987616;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5sA/bJ7zlvzB4PjwB/BzIEOEcwq2h4lfsdHKluSnl6M=;
        b=SQ2MtBy6IDfjWRALRuak1RW+tmT5SFcvYEDLZKrMRPvUkwShd326CxKc6ZEqWs4afT
         AqVSrKHXAK2IgVVOYxI0+tT8/ua4cq3yplHZgLpT6dV39Juw2BI36VZbIz/YwBR4dOhR
         b6FRLw2H1IjWx1TkUEhfkk2QfZB8U1kO6lQ2IMAjD4L6sp/+g4gDsLpsP5793low6sgC
         d8t3WcGvvYnedbDrVGkF3rKuWi0mEtUAi+Lrhitf8tqiUKW1eoo/SwsBTFzVB1riPVqP
         CItLKn9ZtIJxxJKw7OXa47c6TuzP+8KQetE/fCoWhd7qI7ZBue3Ss6tCa5E4ljpelbgn
         egcQ==
X-Forwarded-Encrypted: i=1; AL+hErFlxuuvVsBpVJEFu9hMJaiRQ+yVO+ek86s+S04Sx6+8xQyNtbN3Rwz6gqauLiq6RRrpygPO5Ch2IQ==@kvack.org
X-Gm-Message-State: APuU4Z8svGWaAjiZsBAtwRGNCdmG7nH2+8mUDSM/L8WdNxFvnt1oEOmM
	7kfzu/wwSjYmKxepf0etHCRHYwHn+lYJQHYBCfoyAOm5gjPdfjll0aQw
X-Gm-Gg: AYBFou3Oh3EC+kmBb5fAndmwILZDdd9BvT5h51Hn3kpM8x/Ibl5RppRmVJ0zm9N3gGq
	vjUuJYhA8wtYKANqgf+mOrUc7UyWA16DOnp1rBi1m2qoaFHOKqMN+Hi7qf/HG45Nkmjd9PlfHcR
	kjXUDEolmCtxmJxxfZoBAlFjv84yg8Hkkn843MQ/cQLERerXVyxGZlX8Pup67b3nP22HhbfJYdZ
	ZmPF4jMQUvzvVCVw63QabpDt7ESVfhtIjgCIF3DpHvsLoFtBJYqvhXBXQPYgqmyy4b7GCcCIFss
	bpGk3MIphOdw9R336RQqVK+uDFpRg3CDr5D5ooEiTfX45vP+1e7HOpvEvPG8wnsSHmPWI4dMmEw
	4fCT25m4GsdPesMf4DLa8ApIxdFYJ28a6jKqTMvyU++EY3p8hvdV55Ee51J4zj9Y684t4PcZAbj
	iVqFn7k/xZ5EBF1SjcQow9DVEQ6/59WiXdWtPV2KueIIDL8Dbv9EWCuqh9ems0kQqEeaX//zkn+
	/1jsVmsqES9XskQKqn6Qn+mjWZ0L24oheVSQ0VM+ahnx2f3JV+3JkjDrwsJNkw08857EeRu8QCo
	eDRE08+z9M8GZ/SUyPz05ZEcgbBi+oQWPaUiBsd0WePnOV6KKvBzL95ef4v2QsSzndum/2F/1uu
	TE6qWNwyQhjOXIBJ2t+sC4HKWpQ==
X-Received: by 2002:a05:6a00:813:b0:89d:5a80:5256 with SMTP id d2e1a72fcca58-8bc1c59482dmr1963449b3a.9.1794382816055;
        Tue, 10 Nov 2026 23:40:16 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e110sm1781918b3a.36.2026.11.10.23.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:40:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes
 report infra design (beyond page table accessed-bit milestone 2)
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 11 Nov 2026 18:35:52 +1100
Message-Id: <179438255225.3134195.10613668244848761847.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261017195747.89961-1-sj@kernel.org>
References: <20261017195747.89961-1-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: tzjm85jputjmgw765ejfywj15ucxac11
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8538B180004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794382817-323596
X-HE-Meta: U2FsdGVkX1/fqMkCHRx2e+0/BnXzwxZ3KJaOQteRL+vNFGombpABEiiHb9wbwD7G2tltBpavu8xiLNsWAXSbBFnkKWApfRVKa/sHg5uy6kEtZxuHG0B5nhDTXVZaDehHu7NGy7t5viXATgVj8JsxdM2AqWfki9DmksvlEVKu59XJ5k9bTMqVYNxoSX8oEbJrx75pXy9Ef9lceP/zMdtMhkbzAzuvzGchJjI2CMwtkGgXyj7mkL4RyBTlbvlEipM6f7VHKzVPjwoDSoQCVeyTNCl78UnFhyHJtzMqoZTUUochK64JD/K42PFjer9q2grMdQ8Rr9RXaGII3GWpQJMzDShK4ZxKz6Ws6826e6bmqiWNeNi3WQYK1MjwZqw/z0SAFp1HksP6wi3ZH/dUrf+T7DK02owZeaRpnl7E3aZdNlWSiUawg/VJf7QuN7tt3ru1bugMU7mi4dfcRcYEuUCpI9U+BOUUTd3sf0FoKwWAlKi2wpPRMuTt1KTOTXck6HldEztgXLQlc74ml72j5IGzsN541fMeX1E1nsJtEGG9fj+K/IWoyqIA8HTDEAHnigDD7n2w1xJfyZHyP5PuULwBeSKIewskH/apKnlzuFRBvJF4zzOTfrGGbt0jMTv1rq2oAXcVOlqzPahQp59yI+BgIErffy7y0IgKPq/CwCo661O9s6bP9Q485xR8UyEmYNp0UHT0Q68UD4qsmppeTTYVilEeK+LyQwt+qecPiiEfDJL4xzGYFD2tIVas2Ub86isU8Ag+gNI0pUuiTg7CgeOgX2voWdsi8pFCPfKqseafIVafxdw+kQLgAbdfMVZh7JVx3guQjH/CiMwHAvAKN2HUX+h8uvTNm2r83m2dEjxIcivYiSoCcCaDbuEG/m+QrH71WURDLc/PHha3o//14tqxwqxEfWPmJgPBQzTG3lf+SGZ4aDgYLN3ILOCPqPx4Dhh7ZRFEKhY8q2pofEu8+H8
 SfAD1Y0g
 pc6jcxIabnBuZYgatD8ZFbGGHN9uQNoY1wgpC1rs/WQJVxHB4aYOkcjC1ZxHBzaCNQq762rK009CYAhlajjH57tVw0Uqkv2XARlLdQh2c8iwXoyK4vOHfgGmU85FtGQZUPgkLXqwY9Ee7w5AVXMY/UsCIyQH418ggfW8iuIKgc0+pg3f1f3NXzY9Qm8niVUXgvrP6osOLYV04zk504YITsbk4CbV7NIkVHj/76qJ95LvXehx+LT08y3e2hhB0OIetFJ/bdYCxNtkY88AhSli8fXyi/UTAeGd6/IblB1m4Rtc4eR72mRwqtn2VOMVyrBJCMel1bDtBSEeXl2QHdBLK/Lvt1AM88FVZbDWuTJRfKOsIzjXlZei+0XrRtJQ1O6Mew71H4MC/aHFPZVrgOTR/zdRKpjZZCBMY54gyrVWXQnNSauqY469SdqDbnTKs4v+QjpqQRSoX6THMc9/v65Rz2tHkOCJXHkDw9rSYF+pC1uRgHw6aXt09MyRSIzNCBQAJf2mq7C6r8nOodNHTMVIZsIQ+NUng+pgfIdICsif6OHOFutRqIe+ir4NS9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park wrote:

> +The data attribute probe supports the reports.  The probes can be configured to
> +hit for a given memory region depending on the existence of specific types of
> +reports that associated with the memory region in given report buffers.

I'm wondering how this would interact with the region size.  If each
page of a region is reported with probability q, a region of s pages
would hit with probability 1 - (1 - q)^s, so a large region may hit
more often than a small region of the same access density.  The page
table accessed-bit check samples one page per region, so its hit rate
doesn't depend on the region size in the same way.

A quick replay of the crediting rule of Ravi's RFC v4 [1] on synthetic
traces showed a similar trend.  The adaptive regions adjustment would
mitigate this to some extent, but large cold-only regions still kept
high hit rates after split and merge in the replay.  I'm not sure how
much it matters on real workloads, though.

Would crediting the hits relative to the region size, e.g., reported
bytes / region bytes, make sense to you?  It would need probe_hits
wider than u8, so it is not free.  If you think it is worth exploring,
I may run more experiments and share the results.

[1] https://lore.kernel.org/all/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com/

Thanks,
Aveline Noir

