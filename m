Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52585C98318
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 10:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72556B008C; Sat, 17 Jan 2026 05:25:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5966B0092; Sat, 17 Jan 2026 05:25:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9FA6B0093; Sat, 17 Jan 2026 05:25:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86DA56B008C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:25:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17081D1C31
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 10:25:22 +0000 (UTC)
X-FDA: 84341073684.24.7CBD9C5
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by imf19.hostedemail.com (Postfix) with ESMTP id E2A371A0008
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 10:25:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Ew6l3Jww;
	spf=pass (imf19.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768645520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJtN3Tso6O518lk6TG3q/FJv8yK6/5Vju1Ss6D0LjVM=;
	b=Fkyta5wO1FWAfT5xzpV/IjFRvOEbvSFqdDwVCz1+pJlXoDXw7wtEdt/qxSajuODkhHcVSj
	nLtE1/TQKl+gUFOyk96l42/cDaIQurInXy7EMvjgZKkJYB6dxwEE8EjX8UXbGxpKcrqKau
	/9SNLUDCVunG1CLJDApjCg71/duYRf0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Ew6l3Jww;
	spf=pass (imf19.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768645520; a=rsa-sha256;
	cv=none;
	b=CAVBIF7y/tNCzMKXRBm443HKEBXJwDWSxhl43W5ogvbu+tLE1ZOrfIrrUDULQfbmdt2Zra
	l1R1UhiqCQS9ut6EVeSmhfDMGFCLlhIhzA8HMj945Xs3OrgWn4brwNGnFRolJBlG6lBkzl
	awK7s5MRx//erBw2kQWeCVv3AxMA/JQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768645509; x=1769250309; i=markus.elfring@web.de;
	bh=FJtN3Tso6O518lk6TG3q/FJv8yK6/5Vju1Ss6D0LjVM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ew6l3Jww8khrnEtM/sDfCtr2KRpki8PblUFjCYPNkILjZ/nXpphVFpozMiPliUDO
	 HTh4bbieAHqsFVlP2TEs3TZG2Uvjm8+c3l5EFlJx6WDY8IdYB0z2JrzWYGwnUgKU5
	 evq9DfgxXwdm8DahVSQtrANJd+mF/sMGonQFH1dwGbnXQ4f4Yfy0jgS7mhSoZUkgh
	 3TI4p1jFWcROyK+xVjrazkN+qSD3he2lByBBi5u8AC4QeGxmu+7nArzfTE0adX5d/
	 wrnXtpM+RDkigQvYShtLZABB7EXT/3WfWjFJXrnNrPO1RdZ9Wjs4LUHZ0sGjl4kuC
	 OVVW9fS1gTK2BCnYBg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.177]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MHmm4-1vdBsw3bmQ-00EuTe; Sat, 17
 Jan 2026 11:25:08 +0100
Message-ID: <1b568c3f-2c81-4f93-92c3-5bd109dee414@web.de>
Date: Sat, 17 Jan 2026 11:25:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com, LKML <linux-kernel@vger.kernel.org>,
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
References: <20260116192717.1600049-1-joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v2 1/2] mm/hugetlb: Remove unnecessary if condition
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260116192717.1600049-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OCK5sGmhIf170QoKaPRWPESpveWC2lrlvGXhe5ZWIG4ob8nGWz5
 eZb5joT1FqJk+xOoo2HVRqERVXz1x46CnSMRaTUCwT9f4PLrhdYY91mz/4Ak+EqV9NwcuTm
 ncGzLRNKFAaySJ2gXMp+8EiCpAZY+ZBHECU95XqSx8oqYyVQlaP0SX+5lhpRZdDgxD4DTqv
 vOooGTKbnYMQvW4fvnFsg==
UI-OutboundReport: notjunk:1;M01:P0:gWimdB3vG0o=;q2Juq8yT5DCmiRr+aCt3xdYYHtE
 ievYEVA4RkZOcM5/2WPs/G+OfbKl6ApiGf+JDoYt342ZNeLcHEkk5q2eWdH3xZ23R2BLjOUG0
 MD6UzBxW7EoI31W3ipuslp9Ks5QcwiiYwLpV9pba4RLdONubuzreBl1tquuEbWkl/fJraTTtx
 sp8YIzMWCfQi0VEEFCilGHDCW/c3EA7XNnxI3qJTWPsWQ30KgHJCcfzkZ1jAOLomWxsp0H1B3
 4ROBrA0iw3dXRMA0WA1nYd7uoABoVlloaReDoKqC5VFo7TS0bR8foq8hPYP7CSGuWz3kn5IG/
 6swCrQKKOUQWXfhQtIkNGwQu4dhGwTh0MpOot9XHjAPCYv+8TRFF7BJc0DVcfXE3x+r09FG85
 jLNPLWuKgCco+eIHDslo4fD08q4fpvLOdQwH2JT4qYMgQrpnuDlCn46iNnag6jkOc5lPfEhap
 YlHK9bf4fG37+Np1GPKxKRTC7jEYo55ZGxG83smaED3ZIxPJv3lF2JbOEBFFUOspxRxtyx71c
 upDcK9em46F+OVll8ywMkvYyL89xum0x9zj0g84HvsRUUE+dcp3TKfq3NIxFdLf2LsNeL3ZJt
 jW1tiftx0PLd/OsCKzWZ9LAW4smA4ckIf4iIfmLGN3/rAjlN6dIFb6eCbJRGjGm+cMx0b6F6+
 DyteHSP9LoU3WfOJrOsJmQ7mV6xxA6AIho5DAFQr1EorfmA8YUsvBl7NAyujbueiJQnbVWJfX
 gBlMDW6+L6GJg5Raf/L4XolxyHTYWTvEyxy+VVkZutbBueRdGAi88vbqKDVBUZN8chiEZQm/h
 M1a9hag51pRl8kMt5X9VzLs4NsSIahH823pzZEHX4g0+vEM09dPXo2AnrTjLmJdHMcgxVFxF7
 nofDuhmJJ36I3zU2OhgQ6PwaU4xriqBBxfosIQ6uB2nxeWv1phEZf+yL96wPejAfobzNGLPLX
 IsXUb+Z0N+BQ/DaPXQX73FOmLpAKrHGdDYobV1VAKixIOggDlEJzg7nkyuEIT1gSHMiPp9PZD
 Zf19mvsdPKfKuM9aOtwbtSL2WFHdC/JTk4XitJmcPcmoz6lUKplE4qqWSKEjf82nG3Oghmjao
 XSFBYqheP0Kgev/GxGd1WMY0lP+ez5PM0aLTsL0MIuJgLPkMgJHuA9moLYGeIvesXJz9haDby
 dUAPJb+sRZZW9dj04pXzj0QNkvW65qT5qc4acQHo3enz9xIRra6uPlea8CIy0Uh8f72Yzf6Z1
 oXSfdok6vhf02Y13AB17AKHayzkqgRXC6LULqZnhXEOUnxwnnQa8c+X3HaLokD2hrqQXXN79y
 PGs/d+HvWOLulv0j43i4mBmeKV/h/SBy71p/CwK9YS/f/1jXgWn5qWvASd/8R+u7lfjBIEZ4U
 2LpcwV+vvRvVL3sYCihovetP3fAi2BPtZ9IO8Pvzhdq90FBke40tua5/7aqdNARU7i0Rtqbnt
 DDSynyxeADjxojG1zmVKtOj7gBjSjIEPMKyvaPFXjrAYTSpn2NdkmsSvPvNEPXGjGB1huZA0x
 APtRIQGcjPZgWoiDpn/8eRpF235sN+PvoJkeUFNsMwqzRYBFdEh60//BGfyQxMlLyKQPp1qDH
 6ZNa1fenyJcnU5LUCSvxV+/BLu8ZP/gqnJJZZ3w7DBGF5P58+BgeKeMZK5c217aFhxPUiQZnn
 by7t4Vix8O4jrbu2RFC3XmOIKw2ENcY3lCYI+DVFs7JxGnjrQxxNnd9FVnwL2YzZj1XT5cnqw
 G2buy7SElTq9oxoS1FCQiS3rvx8yFU9+f/wY/7ox7Tn+gXsnnJ/vHVWvKnPwrguTZ2hUB3TYy
 3ZXWOh8pmHEr1LYBh7+W6rokEAEvIdL3kBNwr+LrgceWc0jREA+7PZzdEENkxN3+dWcJ22Fnx
 9DhISJXn7FTTaWMGOmBvfGTfgt3caziwO2bsZC5idw0JMlbGdkS8+4V0yG19wZqdffB/+l3wO
 gKefi3tM7GwSghPVabLmsJd5FKUUt6tUuGIYt+FsVbw+t2u5HyDRjBwM2vsB6q5OuCqtIklpd
 gh2hw1irDz3KZGYgQ2zylK76IN/Tu73fUN9DITAXyF0XRFuFyTgO4yryuBradAW5n0YZ3jy3R
 oOYufBvqbWVXvGsVFRy0Mi5gP6npYbtUsh03+fvphjGJVuKT9u98LYfkJrphx2DUq0UuPWAtd
 FSRN11lfh/nozYz0RvtdpGTbt+HPqiUZVRgcaiVLvXxKj6PyUyE4eoqeE0DsS1z65uwtjQh9R
 KB270Lccds5ZxxlhJox/iOp9N++1UZxaH/+WPLepO4LJrO4FLmjQ2kpDi0QU/BecGrEL95QwI
 OlLGIxoqqTHgCTx/FDuC5rBsDxONAzm/tz1cwcvH3b35xFNOwrNajsS07B1KUwa+R6igV8Hnt
 fVVAfOBjY3oZAlp55CkIL5Oc/Dj9f9EXv3rlPvA69xoZf3Aj0vC8fjPzj5HO10ZqJA2/lLXA3
 J5D64FL6Lqg6zBeIEUUbQ7rOHj1rixVcS+56x+QbVxJOx5zjDIdGurUfxmbH1T2ZEcDBm/W9P
 AIti/bMaA6N/IDTynFYMcFF5XGkdvnzV3NFsO0DJG7QomBtslIiZ30+UnpubziP7BFq/N9cXr
 UzoeCxBazSG8DtJ3GhLc0wUgYwnbIU+cedhiOBzNwLzUJzHxOqQjWrhlh07xOX2VjOEOUwkkH
 9AmxwjrTEIuR993uP0fNrqVzSCG4iJBmeGTKCZPJ1NAqnlg+1EYEklRzF6YN0gGc4IGaH7FyI
 qFkXOPxrTcdaTyApZwfMfXYL54GaOqcle8aWrU5DtYTCibaSHuuE/hqW5sm4WtHhW1HjDmfq3
 eZCvJV7FXzkcIIpHc8RwhWabXvk3FGBVsuJCDCCARoh6V3lBYDQ+jscyqNy4PfJKPVh313Es9
 jgskEVignDO5CgWIoe3Lx1SaygIkZaS+x3vbsmqTVRbdnf0KZvZu4Hq1ngTL0cYFfs9UOM7BF
 K4wiCF0fwqbMeo6c27hbFBklOsPhozS2yYfYG7YR7uka/xf5nnjmrB2T1r4rUY6FSJFRjKsnG
 unWszDN7gAQJEgDTnIOpieO4+mAQZOSg+yGwizu0Bev33Uac0AvwhM1pORZDq946HmlOi9/U6
 eWT6kaGK6p66ph7FifDPw68A0eT6td4g917XSAZGtduXO5pKUXFSGxxE56mxvS2muZowX8Otw
 lAbG4yJ4HsoiJN3/z4oM968P4Ksc9FEhzGugX4qzf/a/8EdLHNdYiEavbtlZ7f3ZQ9UfBR33M
 k72HHUhXmGu0m3cwVUEe9V5wQ4lmy3AQL2bbt3+Bb0BKXnHQuWNLN+PNtILrGn6iEH2eG1TqD
 FQe7QAu4bpbL5JUa4ruKQ3ijvLuPOUPeKsYClbzaEQF3H1EFg4xpGhUKS7GKAiQ0mk75RfrHo
 /tq96pwBC3eMVOEVoX363K1TV1C7TZzdDnMrAaJ3hnVHSn+lfFPCspuiCqO1mhqWdAhBDV+xo
 e6VimnM7MOQKyo+nmNqZdzcF8FJGAk3ffM4HnE/vpQ4FjgzloxuepIF8m+hUWa8o/IsoWqjsC
 4lD6K5B5SBuFoHQOnMvOoCzdG3fFVvou6c0OZIxqwu9FaxFLs14NnY5/fyJeuHBuyd0tIJfTT
 Qo1KG66D5Fm9trRv3uFokLSy2yvwImvEYcfFSR0+N2936SQfHCjTVw4L5kiMrMVtrcMQJ1CQn
 sJaMXf5VmoRCVb5on/78jnjWF3rDxWpHfaJYyGqICR030z2ZYxJcLr5EphObiDhYFSDQjkePH
 RfCRJSv8fCrlNEIiw61WO+uSWBHIhRyYz15xYMThGcFieRx5/4I72TvkSOjjHuoKPMV8UUZF8
 2Lcm84TZpdrl4JLJSS6JbnUCYCXQcVS/A/N9HSbT8IAmMHbvLWtuZPG96g1L9ZM8fg2e1gb+/
 bM5xbT2sGbDIVXldouD5j37s4aszpSd1tN3mDbTp/Xz2/nJrirxTWTV/PHCR2bUIGIwv7SPxL
 u+gBhfBUtLLbMRnZn4SUbbUQCsFEE4et/Gv9kcsJMf+3zDPdiEMieP/Pki0eOMkFYpvB9OGeS
 9jeAkPSz5hHcR9SI9CTihUIfbp/BUB8ai4Cn9Lo5wURpEQbUNhQsDh9CmbDWCTCTP/56PavM9
 PExi3HnlUAS99WiUF3rnmhcO6QxFWyfglbAKEhbzhNu2/d6FCCKFvBNjaTUClCzffC9uMFSrK
 1ALBwcjJ6i6YyxelPfs2ZbulDKv5MelXgxg3XErBR02OanyDU0mcmACfxM0fHIR6Eejj1gIhN
 3sQnV28SoMeXrDYpp1KSh5OjO4ZO8c9nZApcnvEdRSv+kLe/oXyR7/25Dr6k7rFzJMrOJDaXO
 59+wz5i0amOhMJDwp4+8H4pFntCtHEv0GK5jlj2g8npQS1qqk5v3WHdfhbnxSHZUciZaUuk3u
 EPUQ5N1mFm7QslFvA1O1RlLU/jwFk8pru6IseYFw4XOQqIrtw5ingoaumWLCk0GY881R5cfZ8
 5bXQblTyrPb1CE3jSvTMmoh8QJJOe6xnkmRu6+8fMCcZO0qLZE54eFaZXIiwhPlmO30ISmsXi
 eJcTAwSUxEgmNt6rjLb2TmR6LzA6e+R/tI9nk6+VG1z+Ew2jft0zOiu1IbxFQNGwQKdHe5A62
 nKidcriyC8iJfKL7cjytTAVFJHH9jqeW0roHPhx+cejuC0bZcZe455UV2B31MLTlK40cNMnSj
 TmoIyckrhq5I3Pc3FuH2N6lvPgsdEDLfYZbJl2xSBYpLeAgl+OGnoVupGuKrSrQOINiRsbotx
 RlvDt6IKYvNd/tkujG3sqLV3ScE645vfZ74VKvAQ+EyUfY9qHCGo+BAzbTAfHcQ+KLFVSlsYY
 SJU2JANioRt3bVnEyQ7Pq+Z76l9PX876naMZ9zoUH3ie4/nuUOyEYfi8+lLuu2L3n87DlG4m/
 pajAUPBKnUhXEeDS8sAWg2tz2iaZB5PuSWglG8RUw9wKiVgVELgLJyRHkCRoF9YdneFxS1jcj
 GbqlXRFGkZXDXR00EVxf9vKA4Bdlo6In/9M4h7LAIQ/QMdldQ0jmtZnKlrNXdhWuUcSeLFeXs
 bs9jpGvpBiuhz+SDQsISLrMMd9CZQoxCnV6nUD43sysbKZ3cnGSEvjTe8z3YQl6+oype2L/zw
 XaZeoFdXeFBpyzFal311ZcufYvuFjgit3PkBg5EoLW8G8T0bh/Ih9ZCbBFMw==
X-Stat-Signature: ewhrdidcq49yemdhnr6mudo7ktm39ppg
X-Rspam-User: 
X-Rspamd-Queue-Id: E2A371A0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768645519-980261
X-HE-Meta: U2FsdGVkX19g8AYg2+hYK0CC+vIdp7IAyKpVZvvucV4t+8KHDPUByT+KyrGhvtJOQoHXKfnEhMxGoinW0liQEBVUFPEo8ffnO0oMpVaApcvg7yosZPkgePKR1hesW4rDvS7jUOKazIbOOcBNLeBFpuiJ+pYcjivWbvi0vqtF2s19ICdvPowYknNC2/XCB7zJ7IJFKfjW57/MrKxqZCpTFAQeUP9oMNxZUHGcrtqzkCwrVn01/hWHynajuPUWXpY6n+RKDH5k/eC3ZhoYGXbJm6pLE424c/h732XzNxdyVqfLN8oM7khwpzU90HI4UCz365mn2r7S96b/YZI134YKDtF3y7Sc88uOC0WD0uGKXafjXu74hyEPIWUFlW9RxscMvX722k5iU3Y1bZo085m2ukgQ+sym1hI33lM2HKB7ovJkTRzvjr07dpx7fkz+ln+NI2qtghMeI3yr75KeZnVQzxr/i+JCCxs80KdOuw2mA/M8ByKVUpg9oXR37CA++PGxRfT3nyq7W3gZJr/swWaCnDgxbkSyVggFO5R5jGUDE4hF86RyeXjCi5W0/yROaDxhnvTG7dKDJZSK8fFr+odcu4zZeUdalQlxIziWEELrt4SCNKZtIEW0+GHeLj9FKGOPFwt1rGphi2AhZYaVPp1RDhnzo6WTf8f8N4sciDNlfotI6q68cgg5IgSm5fY7yyUoFDk/GtfXEOxLpb+WDJ4FebjsoplrLia27Y0PxGtHByv9y+solcGoHZZxSr8OFHd2KTFC/z4zBb+lI39QEQI45JiErMds9cpa+hoTKYRt/NyAix2IxAm7wFgS1PkTJNwy/55DFPVZkwmTi6XVTyt79O1Oiq662Ivhzw3tcjM83WnRlGscaeo/B3O8TY1avghnx4JFB7J/nAHwed8fVk2B3ebALvfWqFqsIQ5SWFZ73rEEbDLWRIMlxOsKyQZpdb3Ak0sqiTwXU3aMIDzW5ny
 ygW/6huk
 YNjLeAmHNrqaYScX7o2a5YIflqtR8ruLj72dUHmdNW/E4UXXbDvsvTBmlqKfncWCtVcuKtd+6WMf7ScYZY1BmufH19F1NgBQZzbzpasc11NHv+YQy5l4ImAGI2H0gFEzbGTFy8LkYtnq1pXVNYdy2+9v5Me4JfS3uMffshLXvjFPHQNj4KMD2vTAYvd2T0MI/M/efY/6M+J27VM9kgXqPypp8ZVSL93TovC0JV/KNQNpDp+iTmMmlEkRQCq8AavJGa2YS3+C0XiFSi3WbuKsAF87Qkd3I2+IdFyn0WSow3iOIjDgrXdbRtxwyDQRwLk5q8sp/4ypuE5b7Sy/rXsHTiA9ZXgK/eF30l5uTVlDtsYAaiyApyTdpR/uajAlPxxnddrP+Hztgir0D1pdzB4UpUXDyXp4Q6mvtW0PKtvkPcFVFisU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> Remove the check, un-indent, and collapse the function call for
> readability.
=E2=80=A6

Would a cover letter be helpful also for such a small patch series?

Regards,
Markus

