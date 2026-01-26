Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3C9C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 02:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BAB6B0005; Sun, 25 Jan 2026 21:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18466B0088; Sun, 25 Jan 2026 21:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF99F6B0089; Sun, 25 Jan 2026 21:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD03F6B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:18:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CD3D16065D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:18:46 +0000 (UTC)
X-FDA: 84372506652.27.FC7F79C
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 70400A0006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:18:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X5ZDg9va;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769393924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mR+I9jbU5yn6rnz65CZwC80qphzXuO4jZMF9AzzDjl8=;
	b=JdMIkHgzyeU68NlIj8ilCZsIqAPAkzFngGJoIkf+F3uSxyPi1e/uGwAcrMNND0/Ila6usW
	SZ96F6cwDjAppbYH5/NiJNqucBA+xerYOd1pRHVLnQIY72u5ugu5xTD9YgFIFH51tnP8DQ
	7/XccaIiNjpX2euQPfay7pkPtqlYL24=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769393924; a=rsa-sha256;
	cv=pass;
	b=6QMdEka1zweezQmkIxpRCSVIvMCkU7zxu8r+PTcqrA0Lfxy/FKKTyMPMi9MwlQnAJbEZ5r
	M1fv/jbsCsli32tsTkLHxOMk6wc7Kcb+TnuMMaUQMOGroUYTO16Dc5fOpdassIcm0hMpES
	l2s88ScRFsI/L9nqY2nufBP43sY8ym4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X5ZDg9va;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8946e0884afso77852816d6.1
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 18:18:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769393923; cv=none;
        d=google.com; s=arc-20240605;
        b=j0oT0BRsaaOnV84ON+WGe9j9Q7ajwt6AYwNnI5EnjXhbzaZx3GdjyrKucqqRLg3vEG
         gCs6pAyMCEHgWTaVOI22uAdZjNype76frcWer6YhEfzXuL5sI42edUd2EIvCtcXJ/O7L
         s2pQ0ebHMpgV3gQ7S0Gz2KbObhPMRR4oO1BU4YuhB9k4PTA5Pq8OC1WbWOVHNFnqZSXK
         c6KC5Jek7+f2+gTVamVaxhrBzPP+DtTP5nD6I62ZpuQkgXVxqPijAxgUsCIyj/CDQbVj
         dfaLwLB9FXKJ5dbaiOUS0DOF8ZlVif9dOecFci5R2lOOxlV7WrCwGrgCP5TmB+fx2jRV
         TZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mR+I9jbU5yn6rnz65CZwC80qphzXuO4jZMF9AzzDjl8=;
        fh=9bzvu7lsdtn42mIWV7yMxv5CiNrVmAiEGwD2rtZFMr0=;
        b=eO1rhVI15UBja/ZkrENK514f6j7zHCLE+P9jg3nGUlyr4J1FZKWsmuYDKcqY79I5dn
         5yR+aRBPc8O3jT0HFDgzGC0/njo22dx3fDqcAhsm/aQWw2Sl/nV7PxrsR9fyZlP2q6sv
         hr5ohSd1RTZ7RFEx3xqj6H9VnQZE2W6Pvm8Zi9Se106ATowD5PGi7Y9G8ftJA77jtQvN
         Dm+VVqsWaSHbrLniBJYpU/MaIOXaiF7oK1kvOa5JbiiTQo6lvQsdHbJkT/DmhNy8gI7G
         KrYzs55KndcaFE5qF1ndzsm8eqiBQAvmUZ0eVRG+OyoUWF0OGmfDSnJH6yqu7UqY9xkn
         K/8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769393923; x=1769998723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mR+I9jbU5yn6rnz65CZwC80qphzXuO4jZMF9AzzDjl8=;
        b=X5ZDg9vavi0uppzlE5LqkJnM8013sf48gQhnj0WZOCNeK6RovUlDg36R+3nXQl83Q6
         Y/9S5fh6K6CgVFVWRjxR3UAj6e+XFjA8V4rO5kPDQXxCJ6K6WKWCZCFFvFauDJE1oOrN
         +Z9PwOi+FYd8fx7ppZcSA6fF7pNcFFjja8f/CLRoYAFHJpPgglwxqS9tQMJOz1Km/5mQ
         UNGf0lpLurEGn4GnI0alk4jUnK+rvb0s+MIMwGMxdnHbs6C9YxassyuvSs9Xn+ngNQO8
         +5YYUA2Q083Qt0R67yCUwu80wNrleOGizDBqMOrYU6PWzBifIfKDNtKnBd787mucJkrk
         R1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769393923; x=1769998723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mR+I9jbU5yn6rnz65CZwC80qphzXuO4jZMF9AzzDjl8=;
        b=sC8yvBIbmrFlQfOiqWlzzJDC2h412qukWt0jJCdxuqfkuuVn8kt57b3+er90xtfpbN
         sL/LF1hQIpErZpOWWvjDHRjDpOTiey29YtJ/rEy9WbDPoh7fPJAv+CpB3BEwCK2PoOHE
         4ixs+lsDzOCTvZSnwAD5biCi3XzBVhDLu8piyPONpkkK3qhjoPgpNWBn9ead20d9A86H
         frLpclG+QNDUd3CMK7XypxBMrhyuONbQ4hQqQ95SGe/y2tgCTKX+icNkTOvM7MwpmXbc
         W14Y5q0WD3/1zGkrIa8I01t2XNdx6StG3tTGcpLwwGcvysYcA63vSOtZuTAw7ItoO+qK
         opUA==
X-Forwarded-Encrypted: i=1; AJvYcCXCbPagnY5qF8Np3uC0/ONsOtQ/AvJVJ+M6ZoG9N+Hl4flabgxD1wbRvStc/4z01sbxotDueXqoBw==@kvack.org
X-Gm-Message-State: AOJu0YyJ4u6iwnPj1JEZYvMubJldJsr7VBjd4RLNytZGMnR/gh3Sl3UE
	Q/14p/aw8VZ4SbQv1gI0bIMX4VwtSWFKli9sPpxYT5js88hM9AlkQ2cMqu3TcCNoNWGrIczV3uG
	SNE346oQ0H6iTDD3BINQseCNgGpiSfTTW2GW8
X-Gm-Gg: AZuq6aJ5abWcwcJ5cjYWO53s62iveS8raQbX4dCCWZRL5qbKblkNCD+J3egpbFkFTfy
	dXBr4HP3c5I2/x+8D/szjWhbqT2hLtIFjBCQ5lQv+QJLl0NTC1WubcD7K9PlNzHMorEe/nMyuJw
	nMnSxDyFOdLvB2BJMcDvf7+x5+X1thp8MTwAAEKYMvKc7394s6zCN+mkgok0T6DkF0UN7cGltiq
	ZI2ACI//iUQ1q31zymZgf8w58bOKJywG061uv51k9Os62c7cX0/pqF7LS3CqfwxHdP6Bzeeul4v
	OBjiFcBw
X-Received: by 2002:ad4:5c4e:0:b0:721:a9d7:297a with SMTP id
 6a1803df08f44-894b06cb1b6mr36709066d6.7.1769393923311; Sun, 25 Jan 2026
 18:18:43 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-6-vernon2gm@gmail.com>
 <626132d6-360d-4655-804c-f36220b6f669@arm.com>
In-Reply-To: <626132d6-360d-4655-804c-f36220b6f669@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 26 Jan 2026 10:18:32 +0800
X-Gm-Features: AZwV_Qi5vUjcGqf4nRhReHjzUxsIFJxzKcMg2XhQVU-4bQ2FMiFEil8qbk93H44
Message-ID: <CAGsJ_4w1x_wh23sVPcFWiNrUwqUnbF68Vp62UE-rwVHcBmMynw@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 5/5] mm: khugepaged: set to next mm direct when
 mm has MMF_DISABLE_THP_COMPLETELY
To: Dev Jain <dev.jain@arm.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 70400A0006
X-Stat-Signature: opat6dmfuu7fhpp7rfb1oxhtybrq5rn9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769393924-963422
X-HE-Meta: U2FsdGVkX1+jGbpICbgrk9+DDQNOKGHRr7y2AtmCMFlQwrLLjZlCKV1ynGJKwtqRLMA6Ex5+HrNUDdTzbJdSRLElDuV77M5+K6nTHG/9MX5lp6xoNyRJikJRBCDi+htn/7MZrfhTYnvK2hKpSh2d8JGYnHAc0gt0e9QR0BcTZz6JrORWj5kOdCJ9rbVrxAdZ6i7m7hkOS0kD3ua/YyQiPNoB5VmtQjOMsK17SE8n6t1ujURfLYFy1F5jLWNq+ldD98lv3//Muwp46pywz39iRfo4xawYKdXgQgIKZjWg3InfD21j7XE4afJdpicPx30w3jQEuRCh8BzW+G6OYFfFZ2RqSAeBbrjSiwKBuaMQJDWD+AbjrLKSQGMtqF9YVA6/87Pn1f8dIIeuC0zGBEXD3FjWqEgbW7uzhCnbbT4XeGAFIDW2X25+irrOvt3ipotKYTjkNqMBXgNsTIPfMKYuU2JU6jaoJhcpypauh3CZx5VUVM9yjUtE6GMQ/4VuH792ee6nyNr6zNUNTlqLl1U0LHeug52OSQNis3AqWzaxd+eXEnzKUyw/kVNTa2nw6Bz3SDSleCdnbAtyiAudINfxaz561RdKjWllyXKpeH2dJ0tmnUyyhWH1+0JP150JQUdnr6phi1QdQA5i1pW1k5RKcwMN5GHJl1eqzhog1BuNfVx8rPOf05kdIvjJz+0j4+bsw5tyhQ819uGMu6A1ZbeEi3P9HK9fZyqiM0jeWWvjLhwYDugMYWxsNSAYXJEcSa3Kt77kHyjTxZ3d1t6QoJ/zRvYCDt1DSicBy8acxZ2gi6rAh/cJ89+WPAqUY9hfkSzJy+e6VMcdn2iBtux12MKk4MN2OKimLRckfQojA6O7n2fVePOJnJvHCDXABO+ikgtPfPwGWvxvkY+9EYXz1iBgECuEK7z0cLlA0IsIMVHSkQIsazVvDVVyNtGQS1wyD9AFq1u5/Q05f7CeSh6+ZfE
 XRg5RRjl
 oksVBsbDjDhxgXRrmuIrlOIMpx0gexEu4uC+QonMm5m+3T9+Wif+2Eyv2u77nmVONQ0hCg3pKc7kvpjq5FAmvUWSgKeEWO1H66k27gBP2dBMNB0eyfLcaYCIWPL4W6Q59rkWaQkT2u3A97etUQd/Mn9zTpTeVwSlVXg//Yx23vB35nzmYIn62I3arCDu/0m+MblywIRsRZOkRmAmeHOF20A6qy3HXa0AuMbj4A5rk3mDL71UF06xpDPzoAZLeWNrO2DBAUVRv1ivGAnSBb0bpCy886jU9L3f6AQsCgpbeI7r1gPgFELXoGawvRCS6yYgwIG7NoYAfQeQXZtq3fxXvYGulO9uiyu4FpUSrPmGbzCYEps//wvg1rR9pN4ImqOsf19znPso/P58Wik39TV/9T9uzcjbrzXG6B/qlphiUVr1pi0kwei4kPR+6LkQyDsmUCcXOJuiKjA07kiwwB42kNksUexMaeN8/ijRMjSk1x81CvDIgnTm1f/IijaYEJvpzmAE6PSiTtaPzvn4bqfLpOseHgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 8:40=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 23/01/26 1:52 pm, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> > reduce redundant operation.
> >
> > Without this patch, entering khugepaged_scan_mm_slot() next time, we
> > will set khugepaged_scan.mm_slot to the next mm_slot.
> >
> > With this patch, we will directly set khugepaged_scan.mm_slot to the
> > next mm_slot.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > ---
> >  mm/khugepaged.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index be1c09842ea2..1dc19c1b1f97 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2558,7 +2558,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >        * Release the current mm_slot if this mm is about to die, or
> >        * if we scanned all vmas of this mm.
> >        */
>
> Need to update comment: "...or THP got disabled".
>

+1
With that,
Reviewed-by: Barry Song <baohua@kernel.org>

