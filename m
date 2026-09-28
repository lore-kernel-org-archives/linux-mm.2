Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43291CA5FA6
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCA96B009E; Mon, 28 Sep 2026 07:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594496B009F; Mon, 28 Sep 2026 07:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D12B6B00A0; Mon, 28 Sep 2026 07:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBF16B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:02:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0B0AA495F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:02:30 +0000 (UTC)
X-FDA: 85262882460.18.B678796
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C39C80005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:02:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5xX1lSh;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1W7l83jUfjOncW8PpsfsUeV8UefI+hmLcibr0Kwb2lA=;
	b=ZNW9ZVLXtOgv50RRcX4NJXdaj8yn23r2i0Z3DerThSmSFRzz8XEVZR4UQ5x81R9X9vb98U
	AnqEUAX7spVc5EDSqZgqR74QW62Z1GTnLlHKYGlyCOndaLr0otPwlEGX+37BY2EjtHBnh7
	5xUccBxaylhG/xERXDpthmI/PUTUW38=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5xX1lSh;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593349;
	b=S/ELDAxXzleMiSC3OAkox/T3WAbHpbLYcg6FRuoWWI7CrC3j+ekom5/gC1Jn+bSkZo/Kie
	vLR48o2SB1aam7Ka5HSXSKG9i6IDHSkfW/Q2PuEkZY6/pbOsXnFYVDqBSXF08M4S1D6DYO
	QqdwQIbhfwnohKdxoxa/SY+elJCrE9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AFD6436B3;
	Mon, 28 Sep 2026 11:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFDF1F000FF;
	Mon, 28 Sep 2026 11:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790593348;
	bh=1W7l83jUfjOncW8PpsfsUeV8UefI+hmLcibr0Kwb2lA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K5xX1lShmpX9gshtl6gLw77w8dT+LjbmwtZFY8t5Dl/buHBhU/6Ohi9vnSWJUOUPd
	 rCqX9TY3Zmx1/wY2RCywDM0Pjei19fgcvxg34JLGGf4OoRIlLYf1hT73Kc9CYEijJK
	 Wedf80nHwYuvXCL/VQzZYhsTXtN/OMeqGSTMdKVFh4W6l7HhcNBXSatsIUky8RloVn
	 lPFmOTL5wdGQFLdnStZ3WYujaZ5UVqzPH/dTMPSLP1R2G9bNW3wJ3KwpbVkQoFHTn4
	 LKGsMN2V/v8UOC+lI0aouU6ethezKEqKSOEkwQkmxJx05H/r7S9WnAoQ+0LS/lZUYc
	 8VxYaWsBFWDQQ==
Date: Mon, 28 Sep 2026 12:02:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
Message-ID: <arpJBaUzzsLEZgDy@gremlin>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-2-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926010819.604346-2-thehajime@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C39C80005
X-Stat-Signature: 5e4k5rdipfobp3j155dgbjbx9nzbdn7a
X-Rspam-User: 
X-HE-Tag: 1790593349-772556
X-HE-Meta: U2FsdGVkX18nTEO79Rbl33oWF1GHkmPQwJO2G/cLJrAmPUGhNfFGWpXK6Zk4M/PvChjQMBdvYG/jzMrc/9sdvMsJDH/eMp6YqD+XXoJFJVITrc6li2LATH9qsVyx7KSfJOrqKDFONrYRJP4sSTn3LHYWdmue2lR4yRFjME2l4J/30ZG5CljJZCFUrk2ETUUMusW47rcINSWJZFvhjOrRiefiTsSxYDL4zQJQCM6pjNW3bvCJYVmcjd8qpN/fj+KfKN6QJHCf0w5/9/QWfsH8xO8kCQIOmJuAcwyP8hx++EbM0JKo9gibYmI2POV97FYZzTvdSyRTtm/enJVOpn5eWnXI99xFgwWAAPSeJxFv1GrvAyRfysvwcnGzAJGZ6JRfu36Ug5XvxR0gc3Kwet8oMmuchle6V+axEsPID/JINsjYIqiLX7gvd6AYnQ3l75HXdM8v8vlMkhi6GsyY/ob9QqvH8YI35yObtlpeKolGsW8zHs6KJy6ROIakFNhqwR5NQOJymHWsl77vZs2F/mC+mvKBfPmFcxo/wYDdM5a8Mnu3pK3inFPE1c3O/ESbTuRn9wQpSUV7PiApW90qa+a6Alf5JsFJ9e+e8BtbuMNTrojNnuncZQ+uOicTCdGo5c3/yRlRYI15en/tXHfEWRyQYa49c4ewFiwg0gbLywBI7+WEvUP00oHBst8JpAOR8oRXdcwO+Be2osTQwZ1m5bcPZDJRwXag6hkrDtIUUoozeRLiFo5JyuX/FEPQXec8VaFhxUOutci855dwxiYBledJwlN0brmr4xCrxcwjYwh0xJ4iPCcfLX6RtjnjvJtKIXXsHbxOA7/9Nl5mc94I1wpYkoKGnM4Apmr2yKfLVLxC7k+i4XBqDecgosDLqEpfxq4ZYIamWBttGbDM+ctaSH/HH01A/aWoT3jKff3EYmOOLV5p+gpF4VVfd3ZkUH8BH22Ccp3em1ALw5bEKfMi/Zm
 0BnNbtcz
 S5i1tZqr+SI1XhB+DKsYshESWxLkurD7KTT60nZHiPd6yn7CX3EEfyL/AyHClVf7hs4wXvkGOsHzI7lXFdlhBvThalk5Ix7Io627qDiZFMH5kxc02QEpqsmVY2hxZlothrYosCvVP5MqI2uon4cFVuD7MXG1ovKTDfuTstsroGZNMayfpr4xNz38aAtloHm25ZzpFvxPr1fkNhoyETwa3J53F4qu1bs3mYhcqH+p2zRDEmNYo76fnXx9QnY81ash/Ii4/BCmDL/31Ev8bua8I3h5Aq/SGeVnbn7OyUlLkaw2YjB5N/G0KTPcrrBP2Ugzacyw6tGaBiqNLJYBJxT4TqhLtx5PLu+NYdmtcF/D26KTkxxxBy7h8XN4/jXmj5++1B9p2dkGGh5G2A1ZqWczf5yH2oaUDAsC/dkYF2eK1PCj+9LnVCjkEp7jgmGccLrnSwE/lcMphWjYKyjJYi3wb/izEMdJNKfgDIP9sRcf6p6zqsT6qmZ7UwRRx+mJPky2rXszbq+rerujslj4Yiep8ACLKKC+CZ+c9cnTcQNcOc9jN3thR5XdCQNnKhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 10:08:17AM +0900, Hajime Tazaki wrote:
> The kselftest runner currently uses `cd -` to restore its working
> directory after running a test.
>
> This is not supported by the minimal BusyBox hush shell used by some
> NOMMU targets. Store the original directory explicitly and restore it
> with a quoted path instead.
>
> This also avoids printing the directory change performed by `cd -` and
> handles paths containing whitespace correctly.
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

Looks fine to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kselftest/runner.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
> index 311811dc55a0..8fc1018d6fec 100644
> --- a/tools/testing/selftests/kselftest/runner.sh
> +++ b/tools/testing/selftests/kselftest/runner.sh
> @@ -130,6 +130,7 @@ run_one()
>  				return $KSFT_FAIL
>  			fi
>  		fi
> +		OLDDIR=$(pwd)
>  		cd `dirname $TEST` > /dev/null
>  		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
>  			tap_prefix >&4) 3>&1) |
> @@ -147,7 +148,7 @@ run_one()
>  		*)
>  			ktap_test_fail "$TEST_HDR_MSG # exit=$rc";;
>  		esac
> -		cd - >/dev/null
> +		cd "$OLDDIR" >/dev/null
>  	fi
>
>  	return $rc
> --
> 2.43.0
>

--
Cheers, Lorenzo

