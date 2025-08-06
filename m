Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068FAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6608E000E; Wed,  6 Aug 2025 12:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE2C8E0003; Wed,  6 Aug 2025 12:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BCCD8E000E; Wed,  6 Aug 2025 12:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 692A88E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:46:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 135311A06EF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:46:59 +0000 (UTC)
X-FDA: 83746912158.29.28516BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9619A140010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:46:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7u4orDW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754498816; a=rsa-sha256;
	cv=none;
	b=Rt99JkjTOVzcif0IMk24BNGNfSMEOYcM1km36ekIS5CYfBbM6cnwbTgl9X1Q+IbY0wkly8
	3N1K4XixGz1uIGZ520DczH3o4PIiH1BJDHpHCot3FuOfl+cnzWgyILBr/YLa3V/cVkQkh7
	sdTZoqVFsr6sx0zSEOdfAzca1RM9kCQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7u4orDW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Nd9MFnTlr7WVrR7s+mCfQ91mGkWMSL7YSOVN2ZEGg4=;
	b=VaatbknEj8r4/mmGojFxb6mxs4NDEpCp+EroAdRKNzrtIKbTmnxd3OsxvUy5jTIxA658sw
	W5uE1ZjX2W/kxWaz7EgMVxJA+oaEKd1SZscJAhBznxKM6Z3HchlZm4eRh4dyySxM9ZuDr5
	nNUkcSKLyTrEpjvWA8l7Cll4PJX2cdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754498816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Nd9MFnTlr7WVrR7s+mCfQ91mGkWMSL7YSOVN2ZEGg4=;
	b=N7u4orDWM4HIkOShClDFQKkWIk4j/RmRI5JPZDDShyvGzmxAXo47PHF/0viF90Bu5fXzMf
	haMR5WdukODZNPvnDWcpls7KZ/sROg0N71mzYQbO/5hToTvzgK32QVDFFu90SNTT/v+KDE
	hAH5pHyNmneOAYj0eOvbvz8VobNYRVU=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-bmMI13uvOwWpaUGozlE4bg-1; Wed, 06 Aug 2025 12:46:54 -0400
X-MC-Unique: bmMI13uvOwWpaUGozlE4bg-1
X-Mimecast-MFC-AGG-ID: bmMI13uvOwWpaUGozlE4bg_1754498813
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e8d90697a77so155479276.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754498813; x=1755103613;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Nd9MFnTlr7WVrR7s+mCfQ91mGkWMSL7YSOVN2ZEGg4=;
        b=dwdhNe8Kx7vNBvgB/irCYSTJLr8NyO5r4Z3av+UE4eo8Nz/pSKi8soXAEXJHQl2PWA
         N5mP46BzWINJsjK38VOG1ht9F+gOOE67f/y0lyGy3HeSDYgEAR4rk7/kBcIwFrbVFdCo
         ovl4RAFC4rinbBResajNgFZLiZ0BSPXuVOduKPWWZ4yHNt56MNwMcvr8C6VLydLo5+KG
         AAvafA/nASVpQn+gWfZHWFmLtzHd89LMLtbcO0x/Nq0wNxdTz0eVu12G1zGrb62QJoD+
         YZdyE2fqmQUgq2YvPlb5Q29MqRwSzx/j7zvpzEdqKZAfE8WynX4/e50Ui1L4Ldzm2g/P
         diiw==
X-Forwarded-Encrypted: i=1; AJvYcCUMh8R7oADZdRmZIrb6oZAI2cn7ddKXd+nB+9BuWCdnXFht+9rxOex/BAcodd7lAhi0cH0ISkOyrw==@kvack.org
X-Gm-Message-State: AOJu0YyCZt4/1neOXCA+1uNhClmIYLRMtil+Ewjgj4GjLeggS19R9LS9
	svsaRwR5MgpPCiCJ3RbSVsg1L62I/ct7RlxEPBtvzz2OBFEapGSX6itgAiH5OlAXcKQT6Cahq/c
	Wx5UTrwQNVVlz0L5G9JyFhEFLXTK0zrWWF4f9acNVMSzVZsqd9nf1
X-Gm-Gg: ASbGncuifIdfcJSBskg2lu3dTYRs754FIit0giSAQhP+aiKKWkEaoiFnkf/59I7KWNW
	DZH6h/H+Emx9AjEZ3OFBAqyGAMNmSNXQnQUDPf0/JUsKN97QlO04oYa7dTLpjY64pfsvEAeYOx2
	5/pWLxUjUECKLPJXMRAaoNH4O/ftkDXY8kge+v7om0umqnEpHcuNqYqTnoFQdu+EnPlTd467W/e
	bUtR0RhWWM3OJdUhcHy0bU8GV1lodbkojK20kNXdP3BkQTOxmWu9U/yc0GgZZRLo250F0BLXYLn
	yKVpu4wZkeFSqUccraT8R/o8CMPM3+tAwIgL1RpOY9XlDj9zaUI2831i0HzGRSfm+H9owf7Wybv
	ZwLm5cfUrYspOH0HFkL7w4Q==
X-Received: by 2002:a05:6902:1442:b0:e8e:2535:5ce with SMTP id 3f1490d57ef6-e902b825c10mr3495168276.34.1754498813147;
        Wed, 06 Aug 2025 09:46:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE53Eqc4ZZr2AAoa1BkY+1WkbLTnrnGZkrw+oh/AutRhwg1BqQQfEJzXdO3LO6YcxGkkHaG8Q==
X-Received: by 2002:a05:6902:1442:b0:e8e:2535:5ce with SMTP id 3f1490d57ef6-e902b825c10mr3495120276.34.1754498812599;
        Wed, 06 Aug 2025 09:46:52 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8fd3714cb1sm5654298276.2.2025.08.06.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 09:46:51 -0700 (PDT)
Date: Wed, 6 Aug 2025 12:46:48 -0400
From: Peter Xu <peterx@redhat.com>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] selftests/mm: use __auto_type in swap() macro
Message-ID: <aJOG-IAmYhjoYVf-@x1.local>
References: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
 <CAH4c4jJ8VywRUfn2z8HnA73vNxviZ53DZttcR3JaPULF3JFkQA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAH4c4jJ8VywRUfn2z8HnA73vNxviZ53DZttcR3JaPULF3JFkQA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8CAO75AFeFOWQau1iWRRYO59eRcmppPTPjIETxpBLbA_1754498813
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9619A140010
X-Stat-Signature: rt4s67qr6ckyhso7gjyzx3ds13y17pry
X-HE-Tag: 1754498816-418248
X-HE-Meta: U2FsdGVkX18k2Wvd24JCnv9rrCFhRM6Z7tW0ahVD09DxJ/W/CTLSwZ7SiBPfW7g3FFBEfptq3xtWcYfcnl9Lfpmj36EPEx5/m6n8nrZrHec0s74csZCYTHc21c1ca5BhCLlI2s7gmscyyNkUwrNgi3YDKd3BrN5PuZyzfe04G0VoHMhveB/QO64nNS8DVbLOXu0n2F8DtnTUt7gJGFaDb2OXi4vt/ft/cBRB5xKkJaeFz3J/sPpwpdvfqCEl9Bw4zS0cen3TBcd8I2ufJnNZMausYnB96C5vta1N7b9B7IUk9Oc3MRN1SHabe6BIh6OaWTrFWw02JdaK7FpJY4UYrm60L/sqLZbP2DJXvpcqED8d2Uc+1IIqPg8UrRKdyfccFQNE4EtSHjr5LdsRTpCiIq7T6Z9G3PaZcabdnQfqJQjKhsY+bLUlMeIsmzMB37Y5Sy+oRsl//xPg1JrAcpsoMnjucNKrq9LcKf8XNeDcihDFBiblq+DLkYrsXHKhf4fEXRSBIACllp+SfIuA3CSaGjinDU066U0RhIneeWwqKOvZpkqGF06fBLfTkQgNP3iznNe6cDItt7p9T5DFjb3xVpPLrNIzueMy9e3+3RZvbq1zR6LllysAyv4c1tnsu5uMkTRaF7i0qy1mv7LNo11IP953tKovDOSPgZfgSWQFR0N02Fs1xwcb+ngrhlpqMX8VljNm05PFTsiGDvszxz+3SrHIZ+4Mh9rq14dZ7dC/4qAJS1SVRbPGNJAmjvvawXXc/r02o3DrmQJNgDwqOumxW9tyeSagJoNvKSBEG606X+oh/vX50igTYNafelz3neBBLkG4J5ZS+WChXreW2irDuBQZwQ5IBtgFf3ui8r8QQ2idl9KKZWqcbIHTI0mwrjB8TRHxKr+H/MicywNhc02QXZVJ6Qs+JGUtz8VUPLcfadkKo05zIJeqiyR6YM4ts0aY5+1T+m6g9iID/t9QhIJ
 qTSCmUBM
 P6R+ymOm5reLMhaMJy0Y1GbrBAuhF/os2TKocCEmSpH1uzmsDjwzkxgYAJWvvRoYrEcmW3Z4/TRd5tNinuxqAmIN0YnUxe7PWaKdazNWMekPn917sblgUnj268QFoYjQcRhls6Foo9TY7iR/MG1a3VrzmZZoZsilGkjond9k3IpJ4DW5HrSeO+smbJ+fO4lHU0kWMQwfNZ2P6Y+wUJ7nCNsXS1f8oIHd19yt2IzHvluHBcZwwFbCavBXLXbxMPsbHyIxW8xFLEQdImC1H8eHjhI60REbQAWPoNK9fkDPLCYgwKTxdpMNuAd4ea74HS55EuoospCZNBgPtlQvEcvyKSETmhGcb4HwYRnfb6fh1JJxvOnY5S8wohkJCpSCDHT/Ek+c3LB5TbF+4mpzGHfTPu5vXyor/dL/frHhYbNezhPdwJFAr+lFaQ4HA71u1vOajWjc1b81oFuKTPl/4zqPAzvoTbDLAgC9dlMYEbmQePMSRSCioc5o1qZyiO1h/s0hyIdvq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 09:15:50PM +0530, Pranav Tyagi wrote:
> On Wed, Jul 30, 2025 at 7:53 PM Pranav Tyagi <pranav.tyagi03@gmail.com> wrote:
> >
> > Replace typeof() with __auto_type in the swap() macro in uffd-stress.c.
> > __auto_type was introduced in GCC 4.9 and reduces the compile time for
> > all compilers. No functional changes intended.
> >
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  tools/testing/selftests/mm/uffd-stress.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> > index 40af7f67c407..c0f64df5085c 100644
> > --- a/tools/testing/selftests/mm/uffd-stress.c
> > +++ b/tools/testing/selftests/mm/uffd-stress.c
> > @@ -51,7 +51,7 @@ static char *zeropage;
> >  pthread_attr_t attr;
> >
> >  #define swap(a, b) \
> > -       do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> > +       do { __auto_type __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> >
> >  const char *examples =
> >         "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
> > --
> > 2.49.0
> >
> 
> Hi,
> 
> Just a gentle follow-up on this cleanup patch. From what I could find,
> this is the only use of
> typeof() left in the mm selftests, so this should be the only instance
> needing this change.
> 
> Thanks for considering!

Hi,

Andrew should have queued this one in branch akpm/mm-nonmm-unstable (even
though I'm not familiar with the branch).

Said that, I'm also not familiar with __auto_type.  Looks like it's more
efficiently processed by the compiler in some special use cases, however
it's also new so maybe some tools (sparse?) may not recognize it.

Is it the plan that the whole Linux kernel is moving towards __auto_type?
I still see quite a few of typeof() usages (not "a few", but 2966 instances).

Thanks,

-- 
Peter Xu


