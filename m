Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FC5606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kz5/tDiu
Received: by kanga.kvack.org (Postfix)
	id AB8D76B06CF; Wed, 21 Oct 2026 07:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F046B06D0; Wed, 21 Oct 2026 07:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC2B6B06D1; Wed, 21 Oct 2026 07:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76E566B06CF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:39:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1296C1C3C65
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:39:01 +0000 (UTC)
X-FDA: 85346436882.21.4C65F20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64FEEA0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:38:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kz5/tDiu";
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792582739;
	b=ewSIbA6IvbJyCAwANthMcruTbDBNbOXIYBo1bCLAkELQSI9DRRPftKIhbKw2TPs6G9nziH
	EciYxOErc8+r15oOn6BVVNVBP12U7aRZSSB7QpxJVSNRQhxcr9+SetysjR6U6943UQAmV+
	QtpqOYgVOA9bBhYUQ3ShwU8YjRTJwZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kz5/tDiu";
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792582739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtuTGfWk3H7E1gbYASmMIdUVMADE1R3RABXKZ9cs/xk=;
	b=zPorHcopICU++GHDrWmwHVIVHbtpfSqGREQTmAjuk8HiHO1LJZCCFvjUDM+q7E/Lk+34B9
	1erELjNcfjNmaOrzMYPNU7KnZLfBdY1p8cB/c7Y9pvDmgvMAutMyInwKLsVnrDhmOYVyFU
	qSIoIZyI2pgGj0aodEjqyARG3spyLNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F2CE41704;
	Wed, 21 Oct 2026 11:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3D61F01579;
	Wed, 21 Oct 2026 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792582738;
	bh=GtuTGfWk3H7E1gbYASmMIdUVMADE1R3RABXKZ9cs/xk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kz5/tDiuq8Zp96IVC2XIiPJGHoX+4gpgay7d0oEStfPLTU2WdUQTRgl1/EF1yoL0O
	 BU7irob0rKb3sMVDKzMRpIZs7GvhX3Ayu3OQf8z24V8lqQlnUkb6vSsV6V1iO1PTal
	 2WIyuUHLRX3g8T3i7fIc/icxzDroFXTTZxX6bGgQhbAJW7vma2lGUqci7DlhPF9Eh1
	 VhktQ7JzWWWXBUBH3XxR7xxFb+Cw9hj6bqf1xYb50wxzrMAsSK9/pZ5BPX3DjHaAck
	 Se2gn6259qUjypwwgez01jWaRFWrtB7zGEfTWYzVlsKdxq2/r0iUiW9A9w/I+Nd8Rf
	 Tu90+yQSyJ59A==
Message-ID: <sashiko-outbox-180173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/7] selftests/bpf: add tests for the page_owner
 bpf_iter target
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhen Ni" <zhen.ni@easystack.cn>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021112437.1799213-8-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <20261021112437.1799213-8-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 11:38:56 +0000
X-Stat-Signature: j6ynjduf5o4pucjmhkuk1g581m5ktxj6
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64FEEA0003
X-Rspam-User: 
X-HE-Tag: 1792582739-161525
X-HE-Meta: U2FsdGVkX19nQiQwyexTF+or/eXd1M/Ab7i9wxhFu0UyeHhIT5OXy+yUT4LvIND9rsu+qI6JoA7Cmzq0NnM5pk7/MbeTJE7vVJTrgKOG6jNYWZSe4u5zyK76NHHmw2J4MzGgN3tNDeBwNeNFMdL6JsMdbHZtbKiVngK+Ib3s25X3phQOJ0OUNrszF67FUMLWLEEoJzfAcAP6X+i9o6OPyTDfmPKqwvma2SvwWvsbgo0KtLwONgk0fdUHnd4+Gsg5hhoTlmm8Ya0R/E6QrUS3pYViCY/p4J1mHE02dQgwgnj21FhBHa8mbAeIexLtm95hel8QFOYUV4Cv6oSnHPiarI09WlQ8x89RBMwtoN68PRexau3lDT56hhpHyL8QEJh9rTF+Ti2fXWBRM7qLtqBU4Xfx9fbgnDrm4oNcyrpmoDUpPBTEczfS6iFaHIIX5haX5cRsEKIBsXrJ3wv4W0FcziOdOFS/jiT5kFX435ZjrLYXG9C3VFd02UJLpYYwELHaj/XjLAe0nyOxxSWHTOJMe/Vl3bvAcjAq0IpL4yAQgXwIfTNUvhg63c7pQtdECEdEHHZ8b5XagCC4w2Tr0v4O21hRIIMJJ4dh24HDlZ+r8+cbya0SoKYKGeys3ixUgz/3hd00phz3wRLaYW908RFOWyQdowi8vkSlab8R4lD2qBDK+QkKx71iIeVsiV6efyOfVtXnFqAtbZHJj+figkfujUADz85gax7vzYqkQCMgGNh3oYF4FIJ8xUz4yIS9jJBisH5kWMrFKahMG96fUpeVuBCPjs++9YnsVBRaJTfOQRd7tPXT4rU4gotVa9k5D8ALJ0Vmu0XVkBsCmQZxvr81sga7745GB4dX6WPRr3EbGS/a1dAwUR3+6pCk64flKPq4Yyht/X39+UzSDpTpl224GRAKx6gtKxP4SGMOUzyn+wU5ftHxBovOHIt34PnvMZVkZZ0I4CggVXc13/uAf67
 gCfHZfLn
 EGpj0i19mCxTP8E8jYpCPgiJZr/ughoptM9UUAzJuBb2fjCFu6Hg8Me5/jjv3tr+y+q/4M8yVmv3HI9SOJdviXivkWkX6L2h6X8POlnO8G/P180EYxCcyNqbVj8jj0W5ot/9V05c+mxCUkkJvOfS0k1CijV+dOwuSKEGRoL5oCKl8iN37A53gUR+Ig+IioVsDcpeEzYXD+OLOvdAU/gptxsUP5SbWJqjrmd/ZyhFAR3LddPXqbfgY/cYCg21UbGd0H3pBgdW1JS06GOTKWamsXZkxr7TBav99e1oNtVGCaCVSzd1NcLWGEnORUX0SRr1ulHN+eMvmYmcT5U++RD3FBCT37/oClKzPuHxXwpk4vbngtXMfXYB5KHHUou9iHY4mzGWjiF9weXxbvU/9PWXhfNLnnCPTk13IF+4Iy+atv6oyRuOkIvm/8lR6jJjno0jFFVnlbUeevQ1rS+1o/aS0j92iNO4bzlOaAy/utDSkKeELA3PoVsIf8outWU2lHWyeiG9hO2KBTOjcJRwOeC4DvCAEOi+a5+JjkVKYsYiJz1JAi1vstZZ5Gdk+Y8yhTBSPVWuIA+XcygRAz0GfJ3gqcOhdMIlDM+QCWPPnCY4joN+D7Ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/bpf: ASSERT_OK_PTR() on strstr() and strchr() passes o=
n NULL
--

commit c911a68fd56ba0ae206e2cf17e238a8881f03bd2
Author: Zhen Ni <zhen.ni@easystack.cn>

selftests/bpf: add tests for the page_owner bpf_iter target

This commit adds a sleepable BPF program and a userspace test runner to
exercise the seq_file and open-coded page_owner BPF iterators and their
associated kfuncs. It also enables CONFIG_PAGE_OWNER in the BPF selftests
configuration.

> diff --git a/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c b/t=
ools/testing/selftests/bpf/prog_tests/page_owner_iter.c
> new file mode 100644
> index 0000000000000..3684ca3089355
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
[ ... ]
> +/* Validate bpf_page_owner_get_memcg_info() results from the open-coded =
run. */
> +static void check_memcg_skel(struct bpf_iter_page_owner *skel)
> +{
[ ... ]
> +	if (skel->bss->memcg_first_name[0])
> +		ASSERT_OK_PTR(strstr(skel->bss->memcg_first_path,
> +				    skel->bss->memcg_first_name),
> +			      "memcg_name_in_path");
> +}
> +
> +void serial_test_page_owner_iter(void)
> +{
[ ... ]
> +	ASSERT_GT(skel->bss->stack_bytes, 0, "stack_snprint_ok");
> +	ASSERT_OK_PTR(strstr(skel->bss->stack_text, "+0x"), "stack_frames");
> +	ASSERT_OK_PTR(strchr(skel->bss->stack_text, '\n'), "stack_lines");

[Severity: Medium]
Will these ASSERT_OK_PTR() checks in serial_test_page_owner_iter() and
check_memcg_skel() in tools/testing/selftests/bpf/prog_tests/page_owner_ite=
r.c
actually catch a NULL return from strstr() or strchr()?

In tools/testing/selftests/bpf/test_progs.h, ASSERT_OK_PTR() checks the
pointer via libbpf_get_error():

    #define ASSERT_OK_PTR(ptr, name) ({                                 \
            static int duration =3D 0;                                    \
            const void *___res =3D (ptr);                                 \
            int ___err =3D libbpf_get_error(___res);                      \
            bool ___ok =3D ___err =3D=3D 0;                                =
   \
            CHECK(!___ok, (name), "unexpected error: %d\n", ___err);    \
            ___ok;                                                      \
    })

And in tools/lib/bpf/libbpf.c, libbpf_get_error() returns -errno when
given NULL:

    long libbpf_get_error(const void *ptr)
    {
            if (!IS_ERR_OR_NULL(ptr))
                    return 0;

            if (IS_ERR(ptr))
                    errno =3D -PTR_ERR(ptr);

            return -errno;
    }

Because strstr() and strchr() do not set errno when returning NULL on a
non-match, if errno is 0 after bpf_prog_test_run_opts() succeeds,
libbpf_get_error(NULL) returns 0 and ASSERT_OK_PTR() silently passes even
when "+0x", '\n', or memcg_first_name is missing.

Should these checks use ASSERT_NEQ(..., NULL, ...) instead?

> +
> +	check_memcg_skel(skel);
> +
> +destroy:
> +	bpf_iter_page_owner__destroy(skel);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021112437.1799=
213-1-zhen.ni@easystack.cn?part=3D7

